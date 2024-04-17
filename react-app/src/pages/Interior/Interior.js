import React, { useState } from "react"
import { Card, Stack, Typography, alpha, Button } from "@mui/material"
import LockOutlinedIcon from "@mui/icons-material/LockOutlined"
import LockOpenOutlinedIcon from "@mui/icons-material/LockOpenOutlined"
import ShoppingBasketIcon from "@mui/icons-material/ShoppingBasket"
import { decodeBase64WithPolishCharacters, formatMoney } from "../../components/Utils"
import CenteredCard from "../../components/CenteredCard"
import MapsHomeWorkIcon from "@mui/icons-material/MapsHomeWork"

const InteriorIcon = ({ theme, data }) => {
  if (data.owner !== 0) {
    if (data.closed) {
      return <LockOutlinedIcon color='error' sx={{ fontSize: data.description.length > 50 ? "100px" : "65px", backgroundColor: alpha(theme.palette.background.default, 0.2), borderRadius: "10px", padding: "1px 5px" }} />
    } else {
      return <LockOpenOutlinedIcon color='success' sx={{ fontSize: data.description.length > 50 ? "100px" : "65px", backgroundColor: alpha(theme.palette.background.default, 0.2), borderRadius: "10px", padding: "1px 5px" }} />
    }
  } else {
    return <ShoppingBasketIcon color='warning' sx={{ fontSize: "90px", backgroundColor: alpha(theme.palette.background.default, 0.2), borderRadius: "10px", padding: "1px 5px" }} />
  }
}

const fakeData = { closed: false, title: "42 Ganton Los Santos", description: "Ten budynek nie posiada jeszcze opisu.", items: {}, owner: 0, cost: 10000, type: 0, confirmation: false }

function Interior({ theme }) {
  const [data, setData] = useState({})

  const cefData = (switchKey, data) => {
    switch (switchKey) {
      case "buyInterior":
        mta.triggerEvent("interior-system:cefData", "buyInterior")
        break
      default:
        break
    }
  }

  window.clientData = (data) => {
    const decodedData = decodeBase64WithPolishCharacters(data)
    setData(decodedData[0])
  }

  if (Object.keys(data).length === 0) {
    return
  }

  const typeNames = {
    0: "Mieszkanie",
    1: "Garaż",
    2: "Biznes",
    3: "Administracyjny",
    4: "Inny",
  }

  const getTypeName = (type) => {
    return typeNames[type]
  }

  return (
    <>
      {data.confirmation ? (
        <CenteredCard>
          <Stack alignItems={"center"} spacing={3}>
            <Typography variant='body1'>Potwierdź zakup nieruchomości</Typography>
            <MapsHomeWorkIcon color='warning' sx={{ fontSize: "90px", backgroundColor: alpha(theme.palette.background.default, 0.2), borderRadius: "10px", padding: "1px 5px" }} />
            <Stack spacing={1} alignItems={"center"}>
              <Button
                variant='contained'
                size='small'
                color='warning'
                fullWidth
                onClick={() => {
                  cefData("buyInterior")
                }}>
                Kup nieruchomość
              </Button>
              <Button
                variant='outlined'
                size='small'
                color='error'
                fullWidth
                onClick={() =>
                  setData((prevState) => ({
                    ...prevState,
                    confirmation: false,
                  }))
                }>
                Anuluj
              </Button>
            </Stack>
          </Stack>
        </CenteredCard>
      ) : null}

      <Card sx={{ position: "absolute", left: "50%", bottom: "20px", transform: "translateX(-50%)", width: "700px" }}>
        <Stack direction={"row"} spacing={1} justifyContent={"center"} alignItems={"center"} sx={{ height: "100%" }}>
          <Stack sx={{ width: "25%" }} justifyContent={"center"} alignItems={"center"}>
            <Stack spacing={1} justifyContent={"center"} alignItems={"center"}>
              <Typography variant='button'>{getTypeName(data.type)}</Typography>
              <InteriorIcon theme={theme} data={data} />
            </Stack>
          </Stack>
          <Stack spacing={2} sx={{ padding: "1rem", width: "75%" }}>
            <Stack spacing={0 }>
              <Typography variant='button'>{data.title}</Typography>
              <Typography variant='caption' color={"primary.main"}>
                Aby wejść do nieruchomości kliknij 'E'
              </Typography>
            </Stack>

            {data.owner === 0 ? (
              <>
                <Button
                  variant='contained'
                  size='small'
                  color='warning'
                  sx={{ width: "fit-content" }}
                  onClick={() =>
                    setData((prevState) => ({
                      ...prevState,
                      confirmation: true,
                    }))
                  }>
                  Kup nieruchomość
                </Button>
                <Stack direction={"row"} spacing={1}>
                  <Typography variant='body2' boxShadow={2} sx={{ backgroundColor: alpha(theme.palette.success.main, 0.5), borderRadius: "8px", padding: "1px 5px", width: "fit-content" }}>
                    {formatMoney(data.cost)}
                  </Typography>
                </Stack>
              </>
            ) : null}
            {data.owner !== 0 ? (
              data.description.length > 0 ? (
                <Typography variant='body2' color={"text.secondary"} sx={{ backgroundColor: alpha(theme.palette.background.default, 0.2), borderRadius: "8px", padding: "1px 5px", width: "fit-content" }}>
                  {data.description}
                </Typography>
              ) : null
            ) : null}
            {data.items.length > 0 ? (
              <Stack direction={"row"} spacing={1}>
                {data.items.map((item, index) => (
                  <Typography key={index} variant='subtitle2' boxShadow={2} sx={{ backgroundColor: alpha(theme.palette.primary.main, 0.5), borderRadius: "8px", padding: "1px 5px" }}>
                    {item}
                  </Typography>
                ))}
              </Stack>
            ) : null}
          </Stack>
        </Stack>
      </Card>
    </>
  )
}

export default Interior
