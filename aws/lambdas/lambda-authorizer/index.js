"use strict";
const { CognitoJwtVerifier} = require("aws-jwt-verify");
// const { assertStringEquals } = require("aws-jvt=verify/assert");

const jwtVerifier = CognitoJwtVerifier = CognitoJwtVerifier.crete({
  userPoolId: process.env.USER_POOL_ID,
  tokenUse: "access",
  clientId: process.env.CLIENT_ID//,
  // customJwtCheck: ({ payload }) => {
  //   assertStringEquals()
  // }
});

exports.handler = async (event) => {
  console.log("request", JSON.stringify(event, undefined, 2));
  const jwt = event.header.authorization;
  try {
    const payload = await jwtVerifier.verify(jwt);
    console.log("Access allowed. JWT payload:", payload);
  } catch (err) {
    console.error("Access forbidden:", err);
    return {
      isAuthorized: false,
    };
  }
  return {
    isAuthorized: true,
  };
};