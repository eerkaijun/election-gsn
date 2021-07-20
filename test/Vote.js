const Vote = artifacts.require("Vote");

contract("Vote", (accounts) => {
  let [owner, user] = accounts;
  let contractInstance;
  beforeEach(async() => {
    contractInstance = await Vote.new();
  });

  it("User should be able to vote after registering has its identity verified", async() => {
    await contractInstance.register("Kai Jun", "020299", {from:user});
    await contractInstance.verify(user, {from:owner});
    const result = await contractInstance.vote(0, {from:user});
    assert.equal(result.receipt.status, true);
    const voteCount = await contractInstance.getVoteCount(0);
    assert.equal(voteCount, 1, "Candidate should have one vote");
  });

})
