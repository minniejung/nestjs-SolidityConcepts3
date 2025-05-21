import { ethers } from "hardhat";
import { makeAbi } from "./abiGenerator";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(`Deploying contracts with the account: ${deployer.address}`);

  // Deploy MathLibrary
  const MathLibrary = await ethers.getContractFactory("MathLibrary");
  const contractLib = await MathLibrary.deploy();
  console.log(`MathLibrary contract deployed at: ${contractLib.target}`);
  await makeAbi("MathLibrary", contractLib.target);

  // Todo: deploy script를 구현하여 주세요.
  const Calculator = await ethers.getContractFactory("Calculator", {
    libraries: { MathLibrary: contractLib.target },
  });
  const contract = await Calculator.deploy();

  console.log(`Calculator contract deployed at: ${contract.target}`);
  await makeAbi("Calculator", contract.target);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
