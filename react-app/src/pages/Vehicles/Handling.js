import React, { useState } from "react"
import { Card, CardContent, Stack, TextField, Button, Divider, Select, MenuItem } from "@mui/material"
import { decodeBase64WithPolishCharacters } from "../../components/Utils"

function Handling() {
  const [data, setData] = useState({})

  const cefData = (switchKey, data) => {
    switch (switchKey) {
      case "updateHandling":
        mta.triggerEvent("vehicle-system:cefData", "updateHandling", JSON.stringify(data))
        break
      case "saveHandling":
        mta.triggerEvent("vehicle-system:cefData", "saveHandling")
        break
      case "cancelHandling":
        mta.triggerEvent("vehicle-system:cefData", "cancelHandling")
        break
      case "resetHandling":
        mta.triggerEvent("vehicle-system:cefData", "resetHandling")
        break

      default:
        break
    }
  }

  window.clientData = (data) => {
    const decodedData = decodeBase64WithPolishCharacters(data)
    
    setData(decodedData[0])
  }

  const handleEditData = (field, value) => {
    setData((prevData) => ({
      ...prevData,
      [field]: value,
    }))
  }

  if (Object.keys(data).length === 0) {
    return
  }

  return (
    <Card sx={{ position: "absolute", bottom: "20px", right: "20px" }}>
      <CardContent sx={{ maxHeight: "62vh", overflowY: "auto" }}>
        <Stack spacing={2.5}>
          <TextField
            id='mass'
            label='mass'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: 1.0,
              max: 100000.0,
            }}
            helperText='1.0 - 100000.0'
            value={data.mass}
            onChange={(e) => handleEditData("mass", e.target.value)}
            size='small'
          />
          <TextField
            id='turnMass'
            label='turnMass'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: 0.0,
              max: 1000000.0,
            }}
            helperText='0.0 - 1000000.0'
            value={data.turnMass}
            onChange={(e) => handleEditData("turnMass", e.target.value)}
            size='small'
          />
          <TextField
            id='dragCoeff'
            label='dragCoeff'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: -200.0,
              max: 200.0,
            }}
            helperText='-200.0 - 200.0'
            value={data.dragCoeff}
            onChange={(e) => handleEditData("dragCoeff", e.target.value)}
            size='small'
          />
          <TextField
            id='centerOfMass.posX'
            label='centerOfMass X'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: -10.0,
              max: 10.0,
            }}
            helperText='-10.0 - 10.0'
            value={data.centerOfMass.posX}
            onChange={(e) =>
              handleEditData("centerOfMass", {
                ...data.centerOfMass,
                posX: e.target.value,
              })
            }
            size='small'
          />
          <TextField
            id='centerOfMass.posY'
            label='centerOfMass Y'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: -10.0,
              max: 10.0,
            }}
            helperText='-10.0 - 10.0'
            value={data.centerOfMass.posY}
            onChange={(e) =>
              handleEditData("centerOfMass", {
                ...data.centerOfMass,
                posY: e.target.value,
              })
            }
            size='small'
          />
          <TextField
            id='centerOfMass.posZ'
            label='centerOfMass Z'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: -10.0,
              max: 10.0,
            }}
            helperText='-10.0 - 10.0'
            value={data.centerOfMass.posZ}
            onChange={(e) =>
              handleEditData("centerOfMass", {
                ...data.centerOfMass,
                posZ: e.target.value,
              })
            }
            size='small'
          />
          <TextField
            id='percentSubmerged'
            label='percentSubmerged'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: 1,
              max: 99999,
            }}
            helperText='1 - 99999'
            value={data.percentSubmerged}
            onChange={(e) => handleEditData("percentSubmerged", e.target.value)}
            size='small'
          />
          <TextField
            id='tractionMultiplier'
            label='tractionMultiplier'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: -100000.0,
              max: 100000.0,
            }}
            helperText='-100000.0 - 100000.0'
            value={data.tractionMultiplier}
            onChange={(e) => handleEditData("tractionMultiplier", e.target.value)}
            size='small'
          />
          <TextField
            id='tractionLoss'
            label='tractionLoss'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: 0.0,
              max: 100.0,
            }}
            helperText='0.0 - 100.0'
            value={data.tractionLoss}
            onChange={(e) => handleEditData("tractionLoss", e.target.value)}
            size='small'
          />
          <TextField
            id='tractionBias'
            label='tractionBias'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: 0.0,
              max: 1.0,
            }}
            helperText='0.0 - 1.0'
            value={data.tractionBias}
            onChange={(e) => handleEditData("tractionBias", e.target.value)}
            size='small'
          />
          <TextField
            id='numberOfGears'
            label='numberOfGears'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: 1,
              max: 5,
            }}
            helperText='1 - 5'
            value={data.numberOfGears}
            onChange={(e) => handleEditData("numberOfGears", e.target.value)}
            size='small'
          />
          <TextField
            id='maxVelocity'
            label='maxVelocity'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: 0.1,
              max: 200000.0,
            }}
            helperText='0.1 - 200000.0'
            value={data.maxVelocity}
            onChange={(e) => handleEditData("maxVelocity", e.target.value)}
            size='small'
          />
          <TextField
            id='engineAcceleration'
            label='engineAcceleration'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: 0.0,
              max: 100000.0,
            }}
            helperText='0.0 - 100000.0'
            value={data.engineAcceleration}
            onChange={(e) => handleEditData("engineAcceleration", e.target.value)}
            size='small'
          />
          <TextField
            id='engineInertia'
            label='engineInertia'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: -1000.0,
              max: 1000.0,
            }}
            helperText='-1000.0 - 1000.0'
            value={data.engineInertia}
            onChange={(e) => handleEditData("engineInertia", e.target.value)}
            size='small'
          />
          <Select
            label='driveType'
            value={data.driveType}
            onChange={(e) => {
              handleEditData("driveType", e.target.value)
            }}
            size='small'>
            <MenuItem value='rwd'>rwd</MenuItem>
            <MenuItem value='fwd'>fwd</MenuItem>
            <MenuItem value='awd'>awd</MenuItem>
          </Select>
          <Select
            label='engineType'
            value={data.engineType}
            onChange={(e) => {
              handleEditData("engineType", e.target.value)
            }}
            size='small'>
            <MenuItem value='petrol'>petrol</MenuItem>
            <MenuItem value='diesel'>diesel</MenuItem>
            <MenuItem value='electric'>electric</MenuItem>
          </Select>
          <TextField
            id='brakeDeceleration'
            label='brakeDeceleration'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: 0.1,
              max: 100000.0,
            }}
            helperText='0.1 - 100000.0'
            value={data.brakeDeceleration}
            onChange={(e) => handleEditData("brakeDeceleration", e.target.value)}
            size='small'
          />
          <TextField
            id='brakeBias'
            label='brakeBias'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: 0.0,
              max: 1.0,
            }}
            helperText='0.0 - 1.0'
            value={data.brakeBias}
            onChange={(e) => handleEditData("brakeBias", e.target.value)}
            size='small'
          />
          <TextField
            id='steeringLock'
            label='steeringLock'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: 0.0,
              max: 360.0,
            }}
            helperText='0.0 - 360.0'
            value={data.steeringLock}
            onChange={(e) => handleEditData("steeringLock", e.target.value)}
            size='small'
          />
          <TextField
            id='suspensionForceLevel'
            label='suspensionForceLevel'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: 0.0,
              max: 100.0,
            }}
            helperText='0.0 - 100.0'
            value={data.suspensionForceLevel}
            onChange={(e) => handleEditData("suspensionForceLevel", e.target.value)}
            size='small'
          />
          <TextField
            id='suspensionDamping'
            label='suspensionDamping'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: 0.0,
              max: 100.0,
            }}
            helperText='0.0 - 100.0'
            value={data.suspensionDamping}
            onChange={(e) => handleEditData("suspensionDamping", e.target.value)}
            size='small'
          />
          <TextField
            id='suspensionHighSpeedDamping'
            label='suspensionHighSpeedDamping'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: 0.0,
              max: 600.0,
            }}
            helperText='0.0 - 600.0'
            value={data.suspensionHighSpeedDamping}
            onChange={(e) => handleEditData("suspensionHighSpeedDamping", e.target.value)}
            size='small'
          />
          <TextField
            id='suspensionUpperLimit'
            label='suspensionUpperLimit'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: -50.0,
              max: 50.0,
            }}
            helperText='-50.0 - 50.0'
            value={data.suspensionUpperLimit}
            onChange={(e) => handleEditData("suspensionUpperLimit", e.target.value)}
            size='small'
          />
          <TextField
            id='suspensionLowerLimit'
            label='suspensionLowerLimit'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: -50.0,
              max: 50.0,
            }}
            helperText='-50.0 - 50.0'
            value={data.suspensionLowerLimit}
            onChange={(e) => handleEditData("suspensionLowerLimit", e.target.value)}
            size='small'
          />
          <TextField
            id='suspensionFrontRearBias'
            label='suspensionFrontRearBias'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: 0.0,
              max: 1.0,
            }}
            helperText='0.0 - 1.0'
            value={data.suspensionFrontRearBias}
            onChange={(e) => handleEditData("suspensionFrontRearBias", e.target.value)}
            size='small'
          />
          <TextField
            id='suspensionAntiDiveMultiplier'
            label='suspensionAntiDiveMultiplier'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: 0.0,
              max: 30.0,
            }}
            helperText='0.0 - 30.0'
            value={data.suspensionAntiDiveMultiplier}
            onChange={(e) => handleEditData("suspensionAntiDiveMultiplier", e.target.value)}
            size='small'
          />
          <TextField
            id='seatOffsetDistance'
            label='seatOffsetDistance'
            type='number'
            InputLabelProps={{
              shrink: true,
            }}
            inputProps={{
              min: -20.0,
              max: 20.0,
            }}
            helperText='-20.0 - 20.0'
            value={data.seatOffsetDistance}
            onChange={(e) => handleEditData("seatOffsetDistance", e.target.value)}
            size='small'
          />
        </Stack>
      </CardContent>
      <CardContent>
        <Stack spacing={2}>
          <Stack direction={"row"} spacing={1}>
            <Button
              variant='contained'
              color='primary'
              fullWidth
              onClick={() => {
                cefData("updateHandling", data)
              }}>
              Ustaw
            </Button>
            <Button
              variant='outlined'
              color='error'
              fullWidth
              onClick={() => {
                cefData("cancelHandling")
              }}>
              Anuluj
            </Button>
          </Stack>
          <Divider />
          <Button
            variant='contained'
            color='primary'
            fullWidth
            onClick={() => {
              cefData("saveHandling")
            }}>
            Zapisz do bazy danych
          </Button>
          <Button
            variant='outlined'
            color='error'
            fullWidth
            onClick={() => {
              cefData("resetHandling")
            }}>
            Przywróć domyślny
          </Button>
        </Stack>
      </CardContent>
    </Card>
  )
}

export default Handling
