// import path from 'path';
const path = require("path");
// import { expect, assert } from 'chai';
// const { ethers } = require("ethers");
// eslint-disable-next-line @typescript-eslint/no-var-requires
// const circom_tester = require('circom_tester');
// const wasm_tester = circom_tester.wasm;

// const Utils = require("../../scripts/common/utils");

function hexToIntArray(hex) {
    hex = remove0x(hex);
    if (hex.length % 2) {
      throw new Error("hexToBytes: received invalid not padded hex");
    }
    const array = [];
    for (let i = 0; i < hex.length / 2; i++) {
      const j = i * 2;
      const hexByte = hex.slice(j, j + 2);
      if (hexByte.length !== 2) throw new Error("Invalid byte sequence");
      const byte = Number.parseInt(hexByte, 16);
      if (Number.isNaN(byte) || byte < 0) {
        console.log(hexByte, byte);
        throw new Error("Invalid byte sequence");
      }
      array.push(BigInt(byte).toString());
    }
    return array;
}

function remove0x(str) {
    if (str.startsWith("0x")) {
        str = str.slice(2);
    }
    return str;
}

describe('number to array', function () {
    this.timeout(1000000);

    it('hex to array', async function () {
        const arr = hexToIntArray("0x61caad4bb844cefed5f4f3718a29ea78506ad02aa2e8a56e34504e2e0cd9fa90");
        console.log(arr);
    });
});