const deploy = async () => {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contract with the account", deployer.address);

  const FunPunks = await ethers.getContractFactory("FunPunks");
  const deployed = await FunPunks.deploy(10000);

  console.log('Fun pubks is deployed at', deployed.address);
}

deploy()
  .then(() => process.exit(0))
  .catch(error => {
    console.log(error);
    process.exit(1);
  });

