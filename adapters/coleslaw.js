// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell

/**
 * Coleslaw adapter - Static blog generator in Common Lisp
 * https://github.com/kingcons/coleslaw
 */

export const name = "Coleslaw";
export const language = "Common Lisp";
export const description = "Flexible static blog/site generator written in Common Lisp";

let connected = false;
let sblPath = "sbcl";

// Security: Validate inputs to prevent Lisp code injection
function sanitizeLispString(str) {
  if (typeof str !== "string") return "";
  // Reject strings with dangerous Lisp metacharacters
  if (/[()"`'\\;#|]/.test(str)) {
    throw new Error("Invalid characters in input: Lisp special characters not allowed");
  }
  // Allow only safe characters
  if (!/^[a-zA-Z0-9._\-/ ]+$/.test(str)) {
    throw new Error("Invalid characters in input: only alphanumeric, dots, dashes, underscores, slashes, and spaces allowed");
  }
  return str;
}

function validatePath(path) {
  if (!path) return ".";
  const sanitized = sanitizeLispString(path);
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

async function runCommand(args, cwd = null) {
  const cmd = new Deno.Command(sblPath, {
    args: ["--script", ...args],
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

async function runColeslaw(lispExpr, cwd = null) {
  const cmd = new Deno.Command(sblPath, {
    args: ["--eval", `(ql:quickload :coleslaw)`, "--eval", lispExpr, "--quit"],
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
    const cmd = new Deno.Command(sblPath, {
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
    name: "coleslaw_init",
    description: "Initialize a new Coleslaw blog",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path for the new blog" },
      },
    },
    execute: async ({ path }) => {
      try {
        const safePath = validatePath(path);
        return await runColeslaw(`(coleslaw:setup "${safePath}")`, safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "coleslaw_build",
    description: "Build the Coleslaw site",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path to site root" },
      },
    },
    execute: async ({ path }) => {
      try {
        const safePath = validatePath(path);
        return await runColeslaw(`(coleslaw:main "${safePath}")`, safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "coleslaw_preview",
    description: "Preview the site locally",
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
        const safePort = validatePort(port || 8080);
        return await runColeslaw(`(coleslaw:preview :port ${safePort})`, safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "coleslaw_new_post",
    description: "Create a new post",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path to site root" },
        title: { type: "string", description: "Post title" },
      },
      required: ["title"],
    },
    execute: async ({ path, title }) => {
      try {
        const safePath = validatePath(path);
        const safeTitle = sanitizeLispString(title);
        return await runColeslaw(`(coleslaw:new-post "${safeTitle}")`, safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "coleslaw_version",
    description: "Get SBCL version",
    inputSchema: { type: "object", properties: {} },
    execute: async () => {
      const cmd = new Deno.Command(sblPath, {
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
