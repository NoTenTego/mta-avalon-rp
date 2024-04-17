import { Box, Card, CardActionArea, CardContent, Stack, Typography, alpha } from "@mui/material"
import React, { useState } from "react"
import { ReadTextField } from "../../components/ReadTextField"
import { decodeBase64WithPolishCharacters, formatMoney } from "../../components/Utils"

function CharacterSelection({ theme }) {
  const [characters, setCharacters] = useState([])

  const cefData = (switchKey, data) => {
    switch (switchKey) {
      case "characterEnter":
        mta.triggerEvent("accounts:cefData", "characterEnter", JSON.stringify(data))
        break

      default:
        break
    }
  }

  window.clientData = (data) => {
    const decodedMessage = decodeBase64WithPolishCharacters(data)
    
    setCharacters(decodedMessage[0])
  }

  const getSkinColorName = (skinColor) => {
    const skinColorNames = [
      { skinColor: 0, name: "Ciemna" },
      { skinColor: 1, name: "Jasna" },
      { skinColor: 2, name: "Biała" },
    ]

    return skinColorNames[skinColor].name
  }

  if (characters.length === 0) {
    return <></>
  }

  return (
    <Box ml={2} mt={2} mb={2} spacing={1} sx={{ overflowY: "auto", height: "96vh", width: "420px" }}>
      <Stack spacing={2}>
        {characters.map((character, index) => (
          <Card key={index} elevation={3} sx={{ width: "400px" }}>
            <CardActionArea
              onClick={() => {
                cefData("characterEnter", character)
              }}>
              <CardContent>
                <Stack spacing={3}>
                  <Stack justifyContent={"center"} alignItems={"center"}>
                    <Typography variant='h6' textAlign={"center"}>
                      {character["charactername"].replace("_", " ")}
                    </Typography>
                    <Typography
                      textAlign={"center"}
                      sx={{
                        backgroundColor: character["active"] === 1 ? (theme.palette.mode === "dark" ? alpha(theme.palette.primary.main, 0.5) : alpha(theme.palette.primary.light, 0.5)) : alpha(theme.palette.error.main, 0.5),
                        padding: "2px 6px",
                        borderRadius: "6px",
                        fontSize: "12px",
                        height: "100%",
                        width: "fit-content",
                      }}>
                      {character["active"] === 1 ? "Aktywna" : "Nieaktywna"}
                    </Typography>
                  </Stack>
                  <Stack direction='row' spacing={1.5}>
                    <Stack sx={{ width: "100%" }} spacing={1.5}>
                      <ReadTextField label='Imię i nazwisko' value={character["charactername"].replace("_", " ")} />
                      <ReadTextField label='Płeć' value={character["gender"] === 0 ? "Mężczyzna" : "Kobieta"} />
                      <ReadTextField label='Gotówka' value={formatMoney(character["money"])} />
                    </Stack>
                    <Stack sx={{ width: "100%" }} spacing={1.5}>
                      <ReadTextField label='Wiek' value={character["age"]} />
                      <ReadTextField label='Kolor skóry' value={getSkinColorName(character["skincolor"])} />
                      <ReadTextField label='Stan konta' value={formatMoney(character["bankmoney"])} />
                    </Stack>
                  </Stack>
                </Stack>
              </CardContent>
            </CardActionArea>
          </Card>
        ))}
      </Stack>
    </Box>
  )
}

export default CharacterSelection
