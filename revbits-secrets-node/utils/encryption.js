const prime = 23;
const generated = 9;

const getPrivateKey = () => {
  return Math.floor(Math.random() * 10) + 1;
};
const getPublicKey = (privateKey) => {
  return Math.pow(generated, privateKey) % prime;
};

const getSecret = (sharedPub, privateKey) => {
  return Math.pow(sharedPub, privateKey) % prime;
};

module.exports = {
  getSecret,
  getPrivateKey,
  getPublicKey,
};
