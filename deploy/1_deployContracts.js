module.exports = async ({ getUnnamedAccounts, deployments }) => {
    const { deploy, log } = deployments;
    const accounts = await getUnnamedAccounts();

    log("############# Contracts ##################")

    const portus = await deploy('Portus', { from: accounts[0] });
    log(`Deployed Portus at ${portus.address}`);

    const authorizer1 = await deploy('MinBalanceAuthorizer', { args: [portus.address], from: accounts[0] });
    log(`Deployed MinBalanceAuthorizer at ${authorizer1.address}`);

    const authorizer2 = await deploy('AllowAllAuthorizer', { args: [], from: accounts[0] });
    log(`Deployed AllowAllAuthorizer at ${authorizer2.address}`);

    const client = await deploy('ExampleClient', { args:[portus.address], from: accounts[0] });
    log(`Deployed ExampleClient at ${client.address}`);

    log('\n');
};
