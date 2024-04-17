export const formatMoney = (str) => {
  str = String(str)
  const digits = str.replace(/\D/g, "").split("")

  const commasCount = Math.floor((digits.length - 1) / 3)

  for (let i = 1; i <= commasCount; i++) {
    const insertIndex = digits.length - i * 3
    digits.splice(insertIndex, 0, ",")
  }

  return "$" + digits.join("")
}

export const decodeBase64WithPolishCharacters = (encodedData) => {
  var decodedData = atob(encodedData)
  var bytes = new Uint8Array(decodedData.length)
  for (var i = 0; i < decodedData.length; ++i) {
    bytes[i] = decodedData.charCodeAt(i)
  }
  var decoder = new TextDecoder("utf-8")
  return JSON.parse(decoder.decode(bytes))
}