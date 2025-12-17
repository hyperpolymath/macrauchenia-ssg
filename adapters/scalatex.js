// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell

/**
 * ScalaTex adapter - Programmable documentation in Scala
 * https://www.lihaoyi.com/Scalatex/
 */

export const name = "ScalaTex";
export const language = "Scala";
export const description = "Programmable, typesafe document generation in Scala";

let connected = false;
let millPath = "mill";

// Security: Validate inputs to prevent path traversal and command injection
function validateModuleName(module) {
  if (!module) return "docs";
  // Module names should be valid Scala identifiers (alphanumeric and underscores)
  if (!/^[a-zA-Z_][a-zA-Z0-9_]*$/.test(module)) {
    throw new Error("Invalid module name: must be a valid identifier (alphanumeric and underscores only)");
  }
  // Prevent path traversal attempts
  if (module.includes("..") || module.includes("/") || module.includes("\\")) {
    throw new Error("Invalid module name: path traversal not allowed");
  }
  return module;
}

function validatePath(path) {
  if (!path) return null;
  // Reject dangerous path characters and traversal
  if (path.includes("..")) {
    throw new Error("Path traversal not allowed");
  }
  if (/[;&|`$]/.test(path)) {
    throw new Error("Invalid characters in path");
  }
  return path;
}

async function runCommand(args, cwd = null) {
  const cmd = new Deno.Command(millPath, {
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

async function runSbt(args, cwd = null) {
  const cmd = new Deno.Command("sbt", {
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
    const result = await runCommand(["--version"]);
    connected = result.success;
    if (!connected) {
      const sbtResult = await runSbt(["--version"]);
      connected = sbtResult.success;
    }
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
    name: "scalatex_compile",
    description: "Compile ScalaTex documents",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path to project root" },
        module: { type: "string", description: "Module to compile" },
      },
    },
    execute: async ({ path, module }) => {
      try {
        const safePath = validatePath(path);
        const safeMod = validateModuleName(module);
        return await runCommand([`${safeMod}.compile`], safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "scalatex_run",
    description: "Run ScalaTex generation",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path to project root" },
        module: { type: "string", description: "Module to run" },
      },
    },
    execute: async ({ path, module }) => {
      try {
        const safePath = validatePath(path);
        const safeMod = validateModuleName(module);
        return await runCommand([`${safeMod}.run`], safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "scalatex_watch",
    description: "Watch and rebuild on changes",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path to project root" },
        module: { type: "string", description: "Module to watch" },
      },
    },
    execute: async ({ path, module }) => {
      try {
        const safePath = validatePath(path);
        const safeMod = validateModuleName(module);
        return await runCommand(["--watch", `${safeMod}.compile`], safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "scalatex_clean",
    description: "Clean build output",
    inputSchema: {
      type: "object",
      properties: {
        path: { type: "string", description: "Path to project root" },
      },
    },
    execute: async ({ path }) => {
      try {
        const safePath = validatePath(path);
        return await runCommand(["clean"], safePath);
      } catch (e) {
        return { success: false, stdout: "", stderr: e.message, code: 1 };
      }
    },
  },
  {
    name: "scalatex_version",
    description: "Get Mill version",
    inputSchema: { type: "object", properties: {} },
    execute: async () => await runCommand(["--version"]),
  },
];
