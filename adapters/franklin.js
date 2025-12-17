// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell

/**
 * Franklin.jl adapter - Static site generator in Julia
 * https://franklinjl.org/
 */

export const name = "Franklin.jl";
export const language = "Julia";
export const description = "Static site generator for technical blogging in Julia with LaTeX support";

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

function sanitizeHost(str) {
  if (typeof str !== "string") return "";
  // Allow only valid hostname characters
  if (!/^[a-zA-Z0-9._\-:]+$/.test(str)) {
    throw new Error("Invalid host format");
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
    name: "franklin_newsite",
    description: "Create a new Franklin site",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path for the new site" },
        template: { type: "string", description: "Template name" },
      },
    },
    execute: async ({ path, template }) => {
      try {
        const safePath = validatePath(path);
        const tmpl = template ? `, template="${sanitizeJuliaString(template)}"` : "";
        return await runJulia(`using Franklin; newsite("${safePath}"${tmpl})`);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "franklin_serve",
    description: "Start Franklin development server",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path to site root" },
        port: { type: "number", description: "Port number" },
        host: { type: "string", description: "Host to bind to" },
      },
    },
    execute: async ({ path, port, host }) => {
      try {
        const safePath = validatePath(path);
        let args = [];
        if (port) args.push(`port=${validatePort(port)}`);
        if (host) args.push(`host="${sanitizeHost(host)}"`);
        const argsStr = args.length ? args.join(", ") : "";
        return await runJulia(`using Franklin; serve(${argsStr})`, safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "franklin_optimize",
    description: "Build optimized site for deployment",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path to site root" },
        minify: { type: "boolean", description: "Minify output" },
        prerender: { type: "boolean", description: "Prerender pages" },
      },
    },
    execute: async ({ path, minify, prerender }) => {
      try {
        const safePath = validatePath(path);
        let args = [];
        if (minify !== false) args.push("minify=true");
        if (prerender !== false) args.push("prerender=true");
        const argsStr = args.length ? args.join(", ") : "";
        return await runJulia(`using Franklin; optimize(${argsStr})`, safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "franklin_publish",
    description: "Publish site to GitHub Pages",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path to site root" },
      },
    },
    execute: async ({ path }) => {
      try {
        const safePath = validatePath(path);
        return await runJulia(`using Franklin; publish()`, safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "franklin_version",
    description: "Get Julia/Franklin version",
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
