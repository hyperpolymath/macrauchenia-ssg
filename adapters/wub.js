// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell

/**
 * Wub adapter - Web framework in Tcl
 * https://wiki.tcl-lang.org/page/Wub
 */

export const name = "Wub";
export const language = "Tcl";
export const description = "Web framework in Tcl with static site generation capabilities";

let connected = false;
let tclshPath = "tclsh";

// Security: Validate and sanitize inputs to prevent Tcl code injection
function sanitizeTclString(str) {
  if (typeof str !== "string") return "";
  // Reject strings with dangerous Tcl metacharacters
  if (/[\[\]$\\{}";\n\r]/.test(str)) {
    throw new Error("Invalid characters in input: Tcl special characters not allowed");
  }
  // Allow only safe path characters
  if (!/^[a-zA-Z0-9._\-/]+$/.test(str)) {
    throw new Error("Invalid characters in input: only alphanumeric, dots, dashes, underscores, and slashes allowed");
  }
  return str;
}

function validatePath(path) {
  if (!path) return ".";
  const sanitized = sanitizeTclString(path);
  if (sanitized.includes("..")) {
    throw new Error("Path traversal not allowed");
  }
  return sanitized;
}

async function runCommand(args, cwd = null) {
  const cmd = new Deno.Command(tclshPath, {
    args,
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
    const cmd = new Deno.Command(tclshPath, {
      args: ["<<", "puts [info patchlevel]"],
      stdout: "piped",
      stderr: "piped",
    });
    const output = await cmd.output();
    connected = output.success;
    return connected;
  } catch {
    // Try alternative
    try {
      const result = await runCommand(["--version"]);
      connected = true;
      return connected;
    } catch {
      connected = false;
      return false;
    }
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
    name: "wub_start",
    description: "Start Wub server",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path to Wub root" },
        config: { type: "string", description: "Config file" },
      },
    },
    execute: async ({ path, config }) => {
      try {
        const safePath = validatePath(path);
        const safeConfig = config ? sanitizeTclString(config) : "wub.tcl";
        return await runCommand([safeConfig], safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "wub_generate",
    description: "Generate static files",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path to Wub root" },
        output: { type: "string", description: "Output directory" },
      },
    },
    execute: async ({ path, output }) => {
      try {
        const safePath = validatePath(path);
        const safeOutput = output ? sanitizeTclString(output) : "public";
        // Use Tcl variable to prevent injection
        const script = `
          source wub.tcl
          package require Wub
          set output_dir {${safeOutput}}
          Wub generate $output_dir
        `;
        return await runCommand(["-c", script], safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "wub_run",
    description: "Run a Tcl script",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Working directory" },
        script: { type: "string", description: "Script file to run" },
      },
      required: ["script"],
    },
    execute: async ({ path, script }) => {
      try {
        const safePath = validatePath(path);
        const safeScript = sanitizeTclString(script);
        return await runCommand([safeScript], safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "wub_version",
    description: "Get Tcl version",
    inputSchema: { type: "object", properties: {} },
    execute: async () => {
      const script = 'puts "Tcl [info patchlevel]"';
      return await runCommand(["-c", script]);
    },
  },
];
