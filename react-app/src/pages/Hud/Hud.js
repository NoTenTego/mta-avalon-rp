import React, { useState } from "react"
import { Typography, Box, Stack, alpha, LinearProgress } from "@mui/material"
import { decodeBase64WithPolishCharacters, formatMoney } from "../../components/Utils"
import LocalGasStationIcon from "@mui/icons-material/LocalGasStation"

const fakeData = { money: 5000, dutyName: "", dutyTime: "", dutyColor: "", vehicle: true, actualSpeed: 2, maxFuel: 100, currentFuel: 40 }

function Hud({ theme }) {
  const [data, setData] = useState({})

  window.clientData = (data) => {
    const decodedData = decodeBase64WithPolishCharacters(data)

    setData(decodedData[0])
  }

  if (Object.keys(data).length === 0) {
    return
  }

  const fuelProgress = (data.currentFuel / data.maxFuel) * 100

  const GetActualSpeed = (speed) => {
    const textStyle = {
      fontWeight: 600,
      textShadow: "1.5px 1.5px 3px rgba(0, 0, 0, 0.5), -1.5px -1.5px 3px rgba(0, 0, 0, 0.5)",
    }

    if (speed === 0) {
      return (
        <Typography variant='h1' sx={{ ...textStyle, color: "#cccccc" }}>
          000
        </Typography>
      )
    } else if (speed < 10) {
      return (
        <Typography variant='h1' sx={textStyle}>
          <span style={{ color: "#cccccc" }}>00</span>
          {speed}
        </Typography>
      )
    } else if (speed < 100) {
      return (
        <Typography variant='h1' sx={textStyle}>
          <span style={{ color: "#cccccc" }}>0</span>
          {speed}
        </Typography>
      )
    } else {
      return (
        <Typography variant='h1' sx={textStyle}>
          {speed}
        </Typography>
      )
    }
  }

  return (
    <Box>
      <Box variant='h4' sx={{ position: "absolute", top: 20, right: 20 }}>
        <Stack spacing={-0 / 5} justifyContent={"center"} alignItems={"flex-end"}>
          <Typography variant='h4' sx={{ fontWeight: 600, textShadow: "1.5px 1.5px 3px rgba(0, 0, 0, 0.5), -1.5px -1.5px 3px rgba(0, 0, 0, 0.5)" }}>
            {formatMoney(data.money)}
          </Typography>
          <Stack spacing={1} direction={"row"} justifyContent={"flex-end"} alignItems={"flex-end"}>
            {data.dutyName ? (
              <Typography variant='subtitle2' boxShadow={3} sx={{ backgroundColor: alpha(data.dutyColor, 0.5), borderRadius: "10px", padding: "1px 5px" }}>
                {data.dutyName} - {data.dutyTime} min
              </Typography>
            ) : null}
          </Stack>
        </Stack>
      </Box>

      {data.vehicle ? (
        <Box sx={{ position: "absolute", bottom: 20, right: 20 }}>
          <Stack direction={"row"} spacing={1}>
            <Stack alignItems={"flex-end"} spacing={-1}>
              <Typography variant='h1' sx={{ fontWeight: 600, textShadow: "1.5px 1.5px 3px rgba(0, 0, 0, 0.5), -1.5px -1.5px 3px rgba(0, 0, 0, 0.5)" }}>
                {GetActualSpeed(data.actualSpeed)}
              </Typography>

              <Stack direction={"row"} alignItems={"center"} spacing={1}>
                <LinearProgress
                  variant='determinate'
                  color={fuelProgress < 50 ? (fuelProgress < 25 ? "error" : "warning") : "success"}
                  value={fuelProgress}
                  sx={{ width: "70px", height: "12px", borderRadius: "4px", boxShadow: "-1.5px -1.5px 3px rgba(0, 0, 0, 0.3), -1.5px -1.5px 3px rgba(0, 0, 0, 0.3)" }}
                />
                <Typography variant='subtitle2' boxShadow={3} sx={{ backgroundColor: alpha(theme.palette.background.paper, 0.5), borderRadius: "10px", padding: "1px 5px", display: "flex", alignItems: "center" }}>
                  <LocalGasStationIcon />
                </Typography>
              </Stack>
            </Stack>

            <Typography variant='subtitle2' boxShadow={3} sx={{ backgroundColor: alpha(theme.palette.background.paper, 0.5), borderRadius: "10px", padding: "1px 5px", height: "fit-content" }}>
              km/h
            </Typography>
          </Stack>
        </Box>
      ) : null}
    </Box>
  )
}

export default Hud
