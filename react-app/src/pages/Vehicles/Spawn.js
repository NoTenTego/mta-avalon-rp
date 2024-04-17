import React, { useState } from "react"
import CenteredCard from "../../components/CenteredCard"
import { Stack, Button, Card, CardMedia, Divider, CardHeader, CardContent, Typography, alpha, CardActionArea } from "@mui/material"
import { decodeBase64WithPolishCharacters } from "../../components/Utils"

function Spawn({ theme }) {
  const [selectedVehicle, setSelectedVehicle] = useState({})
  const [data, setData] = useState([])

  const cefData = (switchKey, data) => {
    switch (switchKey) {
      case "spawnVehicle":
        mta.triggerEvent("vehicle-system:cefData", "spawnVehicle", JSON.stringify(selectedVehicle.id))
        break
      case "trackVehicle":
        mta.triggerEvent("vehicle-system:cefData", "trackVehicle", JSON.stringify(selectedVehicle.id))
        break
      case "toggleVehiclePanel":
        mta.triggerEvent("vehicle-system:cefData", "toggleVehiclePanel")
        break

      default:
        break
    }
  }

  window.clientData = (data) => {
    const decodedData = decodeBase64WithPolishCharacters(data)

    setData(decodedData[0])
  }

  return (
    <CenteredCard>
      <Stack spacing={1} divider={<Divider />} sx={{ width: "800px" }}>
        <Stack direction={"row"} spacing={1} sx={{ width: "800px", overflowX: "auto", padding: "15px", backgroundColor: alpha(theme.palette.background.paper, 0.5) }}>
          {data.map((vehicle, index) => (
            <Stack spacing={1}>
              <Card key={index} sx={{ width: "300px", backgroundColor: selectedVehicle.id === vehicle.id && alpha(theme.palette.primary.main, 0.3) }}>
                <CardActionArea
                  onClick={() => {
                    setSelectedVehicle(vehicle)
                  }}
                >
                  <CardHeader title={vehicle.brand + " " + vehicle.model} subheader={vehicle.last_active}></CardHeader>
                  <CardMedia component='img' src={`http://mta/cef/assets/images/vehicles/${vehicle.mta_model}.png`} alt={vehicle.brand + " " + vehicle.model} height='150'></CardMedia>
                  <CardContent>
                    <Stack direction={"row"} spacing={1}>
                      <Typography variant='body2' color='text.tertiary'>
                        ID:
                      </Typography>
                      <Typography variant='body2' color='text.primary'>
                        {vehicle.id}
                      </Typography>
                    </Stack>

                    <Stack direction={"row"} spacing={1}>
                      <Typography variant='body2' color='text.tertiary'>
                        Tablica rejestracyjna:
                      </Typography>
                      <Typography variant='body2' color='text.primary'>
                        {vehicle.plate}
                      </Typography>
                    </Stack>
                  </CardContent>
                </CardActionArea>
              </Card>
            </Stack>
          ))}
        </Stack>
        <Stack direction={"row"} spacing={1} justifyContent={"space-between"} alignItems={"center"}>
          <Stack direction={"row"} spacing={1}>
            <Button
              variant='contained'
              color='primary'
              disabled={!selectedVehicle.id}
              onClick={() => {
                cefData("spawnVehicle")
                setSelectedVehicle((prevState) => ({
                  ...prevState,
                  spawned: prevState.spawned === 1 ? 0 : 1,
                }))
              }}
            >
              {selectedVehicle.spawned === 0 ? "Spawn" : "Despawn"}
            </Button>
            <Button
              variant='contained'
              color='primary'
              disabled={!selectedVehicle.id}
              onClick={() => {
                cefData("trackVehicle")
              }}
            >
              Namierz
            </Button>
            <Button variant='contained' color='primary' disabled={!selectedVehicle.id}>
              Udostępnij
            </Button>
            <Button variant='contained' color='primary' disabled={!selectedVehicle.id}>
              Ulepszenia
            </Button>
          </Stack>
          <Button
            variant='outlined'
            color='error'
            onClick={() => {
              cefData("toggleVehiclePanel")
            }}
          >
            Wyjdź
          </Button>
        </Stack>
      </Stack>
    </CenteredCard>
  )
}

export default Spawn
