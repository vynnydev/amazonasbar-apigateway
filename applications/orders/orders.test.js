/* eslint-disable @typescript-eslint/no-var-requires */
const orders = require('./orders.js')
const dotenv = require('dotenv')
dotenv.config()

const main = async () => {
  await orders.handler({})
}

main()
