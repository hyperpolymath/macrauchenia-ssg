// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell

/**
 * Documenter.jl adapter - Documentation generator for Julia
 * https://documenter.juliadocs.org/
 */

export const name = "Documenter.jl";
export const language = "Julia";
export const description = "Documentation generator for Julia packages";

let connected = false;
let juliaPath = "julia";

// Security: Validate inputs to prevent Julia code injection
function sanitizeJuliaString(str) {
  if (typeof str !== "string") return "";
  // Reject strings with dangerous Julia metacharacters
  if (/[;`$()\\"\n\r]/.test(str)) {
    throw new Error("Invalid characters in input: Julia special characters not allowed");
  }
  // Allow only safe characters
  if (!/^[a-zA-Z0-9._\-/ ]+$/.test(str)) {
    throw new Error("Invalid characters in input: only alphanumeric, dots, dashes, underscores, slashes, and spaces allowed");
  }
  return str;
}

function sanitizeJuliaIdentifier(str) {
  if (typeof str !== "string") return "";
  // Julia identifiers: alphanumeric and underscores only
  if (!/^[a-zA-Z_][a-zA-Z0-9_]*$/.test(str)) {
    throw new Error("Invalid module name: must be a valid Julia identifier");
  }
  return str;
}

function validatePath(path) {
  if (!path) return ".";
  const sanitized = sanitizeJuliaString(path);
  if (sanitized.includes("..")) {
    throw new Error("Path traversal not allowed");
  }
  return sanitized;
}

function validatePort(port) {
  const p = parseInt(port, 10);
  if (isNaN(p) || p < 1 || p > 65535) {
    throw new Error("Invalid port number: must be between 1 and 65535");
  }
  return p;
}

function sanitizeRepoUrl(url) {
  if (!url) return "";
  // Allow only valid GitHub-style repo URLs
  if (!/^[a-zA-Z0-9._\-/:@]+$/.test(url)) {
    throw new Error("Invalid repository URL format");
  }
  return url;
}

async function runJulia(code, cwd = null) {
  const cmd = new Deno.Command(juliaPath, {
    args: ["-e", code],
    cwd: cwd || Deno.cwd(),
    stdout: "piped",
    stderr: "piped",
  });
  const output = await cmd.output();
  const decoder = new TextDecoder();
  return {
    success: output.success,
    stdout: decoder.decode(output.stdout),
    stderr: decoder.decode(output.stderr),
    code: output.code,
  };
}

export async function connect() {
  try {
    const cmd = new Deno.Command(juliaPath, {
      args: ["--version"],
      stdout: "piped",
      stderr: "piped",
    });
    const output = await cmd.output();
    connected = output.success;
    return connected;
  } catch {
    connected = false;
    return false;
  }
}

export async function disconnect() {
  connected = false;
}

export function isConnected() {
  return connected;
}

export const tools = [
  {
    name: "documenter_makedocs",
    description: "Build documentation",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path to project root" },
        sitename: { type: "string", description: "Site name" },
      },
    },
    execute: async ({ path, sitename }) => {
      try {
        const safePath = validatePath(path);
        const sn = sitename ? `sitename="${sanitizeJuliaString(sitename)}"` : "";
        return await runJulia(`using Documenter; makedocs(${sn})`, safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "documenter_deploydocs",
    description: "Deploy documentation",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path to project root" },
        repo: { type: "string", description: "Repository URL" },
      },
    },
    execute: async ({ path, repo }) => {
      try {
        const safePath = validatePath(path);
        const r = repo ? `repo="${sanitizeRepoUrl(repo)}"` : "";
        return await runJulia(`using Documenter; deploydocs(${r})`, safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "documenter_doctest",
    description: "Run doctests",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path to project root" },
        module: { type: "string", description: "Module name" },
      },
      required: ["module"],
    },
    execute: async ({ path, module }) => {
      try {
        const safePath = validatePath(path);
        const safeModule = sanitizeJuliaIdentifier(module);
        return await runJulia(`using Documenter, ${safeModule}; doctest(${safeModule})`, safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "documenter_serve",
    description: "Serve documentation locally with LiveServer",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path to docs/build" },
        port: { type: "number", description: "Port number" },
      },
    },
    execute: async ({ path, port }) => {
      try {
        const safePath = validatePath(path);
        const safePort = validatePort(port || 8000);
        return await runJulia(`using LiveServer; serve(dir="docs/build", port=${safePort})`, safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "documenter_version",
    description: "Get Julia/Documenter version",
    inputSchema: { type: "object", properties: {} },
    execute: async () => {
      const cmd = new Deno.Command(juliaPath, {
        args: ["--version"],
        stdout: "piped",
        stderr: "piped",
      });
      const output = await cmd.output();
      const decoder = new TextDecoder();
      return {
        success: output.success,
        stdout: decoder.decode(output.stdout),
        stderr: decoder.decode(output.stderr),
      };
    },
  },
];
