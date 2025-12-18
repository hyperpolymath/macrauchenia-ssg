// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell

/**
 * StaticWebPages.jl adapter - Academic website generator in Julia
 * https://github.com/Azzaare/StaticWebPages.jl
 */

export const name = "StaticWebPages.jl";
export const language = "Julia";
export const description = "Academic and personal website generator in Julia";

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
    name: "staticwebpages_init",
    description: "Initialize a new StaticWebPages site",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path for the new site" },
      },
    },
    execute: async ({ path }) => {
      try {
        const safePath = validatePath(path);
        return await runJulia(`using StaticWebPages; init("${safePath}")`, safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "staticwebpages_build",
    description: "Build the site",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path to site root" },
      },
    },
    execute: async ({ path }) => {
      try {
        const safePath = validatePath(path);
        return await runJulia(`using StaticWebPages; build()`, safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "staticwebpages_serve",
    description: "Serve the site locally",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path to site root" },
        port: { type: "number", description: "Port number" },
      },
    },
    execute: async ({ path, port }) => {
      try {
        const safePath = validatePath(path);
        const safePort = validatePort(port || 8000);
        return await runJulia(`using StaticWebPages; serve(port=${safePort})`, safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "staticwebpages_version",
    description: "Get Julia version",
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
