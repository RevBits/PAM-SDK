const BigInteger = require('jsbn').BigInteger;

function parseBigInt(str, r) {
  return new BigInteger(str, r);
}

function RSAKey() {
  this.n = null;
  this.e = 0;
  this.d = null;
  this.p = null;
  this.q = null;
  this.dmp1 = null;
  this.dmq1 = null;
  this.coeff = null;
}

function RSASetPrivate(N, E, D) {
  if (N != null && E != null && N.length > 0 && E.length > 0) {
    this.n = parseBigInt(N, 16);
    this.e = parseInt(E, 16);
    this.d = parseBigInt(D, 16);
  }
}

RSAKey.prototype.setPrivate = RSASetPrivate;

module.exports = RSAKey;
