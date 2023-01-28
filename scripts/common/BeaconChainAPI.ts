import axios from "axios";
import {Utils} from "./utils";

// TODO put in config
const BASE_URL = "https://broken-dawn-silence.discover.quiknode.pro/d9cba15931e96ca925a52ebdd0afcbecc127434b/eth/v1/beacon/"
const BEACON_BLOCK_HEADER = `${BASE_URL}headers/`;
const PUB_KEY_BATCH_SIZE = 100;

export namespace BeaconChainAPI {

	export async function getSyncCommitteePubKeys(slot: number) {
		const result = await axios.get(`${BASE_URL}states/${slot}/sync_committees`);
		const committee = result.data.data.validators;

		const url = `${BASE_URL}states/${slot}/validators?id=`;
		const committeePubKeys = [];
		for (let i = 0; i < Math.ceil(committee.length / PUB_KEY_BATCH_SIZE); i++) {
			const validatorIndices = committee.slice(i * PUB_KEY_BATCH_SIZE, (i + 1) * PUB_KEY_BATCH_SIZE);
			const resp = await axios.get(url + validatorIndices.toString());
			const validatorsBatchInfo = resp.data.data;
			for (let index in validatorsBatchInfo) {
				committeePubKeys.push(Utils.remove0x(validatorsBatchInfo[index]['validator']['pubkey']));
			}
		}
		return committeePubKeys;
	}

	export async function getBeaconBlockHeader(slotN: number) {
		const result = await axios.get(BEACON_BLOCK_HEADER + slotN);
		const {slot, proposer_index, parent_root, state_root, body_root} = result.data.data.header.message;
		return {slot, proposer_index, parent_root, state_root, body_root};
	}

	export async function getGenesisValidatorRoot() {
		const result = await axios.get(BASE_URL + "genesis");
		return result.data.data['genesis_validators_root'];
	}

	export async function getForkVersion(slot: number) {
		const result = await axios.get(BASE_URL + `states/${slot}/fork`);
		return result.data.data['current_version'];
	}
}