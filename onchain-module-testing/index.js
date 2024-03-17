const privateKey = "32c772a178d3b329ad22df7cb132b08c81a747637de4aacb70b2c2021b99a055"

const ethers = require('ethers')
const provider = ethers.getDefaultProvider("sepolia");
const fs = require('fs')
const msaFactoryAddress = "0xFf81C1C2075704D97F6806dE6f733d6dAF20c9c6"
// let msaFactoryABI = require('./msa-factory.json')
const msaAdvancedAddress = "0x76104AE8aeCfc3aEC2AA6587b4790043d3612c47"
const msaAdvancedABI = require('./msa-advanced.json')
const subscriptionModuleAddress = "0x45aa9BA93db6E4D987854f0B73C98D41aDD36A76"
const subscriptionModuleABI = require('./subscription-module.json')

const msaFactoryABI = fs.readFileSync('./msa-factory.json', 'utf8');

const wallet = new ethers.Wallet(privateKey, provider)
console.log('address:', wallet.address)
console.log('privateKey:', wallet.privateKey)

const msaFactoryContract = new ethers.Contract(msaFactoryAddress, msaFactoryABI, wallet)
const msaAdvancedContract = new ethers.Contract(msaAdvancedAddress, msaAdvancedABI, wallet)
const subscriptionModuleContract = new ethers.Contract(subscriptionModuleAddress, subscriptionModuleABI, wallet)

// console.log(msaFactoryContract)
// console.log(ethers.keccak256("0x0000000000000000000000000000000000000000000000000000000000000001"))

async function a() {
    const salt = ethers.keccak256("0x0000000000000000000000000000000000000000000000000000000000000001")
    const initCode = "0x0000000000000000000000005e9f3feec2aa6706df50de955612d964f115523b000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000002a4642219af000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000001400000000000000000000000000000000000000000000000000000000000000220000000000000000000000000000000000000000000000000000000000000028000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000020000000000000000000000000f83d07238a7c8814a48535035602123ad6dbfa63000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000200000000000000000000000002cce5ed5f0055307a900be9c135ce2b5486da89b00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000020000000000000000000000000be684c68740db2f4efa0609dcd8ed443031f98f30000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    // const transactionResponse = await msaFactoryContract.createAccount(salt, initCode)
    // const msaAccountAddress = await msaFactoryContract.getAddress(salt, initCode)
    const msaAccountAddress = "0xF123a58aD728DfB628FaD6380D5622F636E9Cdc1"
    // console.log(msaAccountAddress);
    const msaAccountContract = new ethers.Contract(msaAccountAddress, msaAdvancedABI, wallet)
    await msaAccountContract.installModule("2", subscriptionModuleAddress, "0x0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
    await msaAccountContract.installModule("1", subscriptionModuleAddress, "0x0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
}

a()

// factory.functions.