import axios from "axios";

const client = axios.create({
  baseURL: 'http://localhost:3000',
  timeout: 1000,
  headers: {
    'Content-Type': 'application/vnd.api+json'
  }
})

export default client
