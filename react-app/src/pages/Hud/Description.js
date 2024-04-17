import React, { useState } from "react"
import CenteredCard from "../../components/CenteredCard"
import { Divider, Stack, TextField, Button, Box, Typography, alpha } from "@mui/material"
import Tab from "@mui/material/Tab"
import TabContext from "@mui/lab/TabContext"
import TabList from "@mui/lab/TabList"
import TabPanel from "@mui/lab/TabPanel"

const fakeData = [
  { title: "Testowy opis 1", description: "młody chłopak w luźnych ciuchach, na szyi widoczny jest mały tatuaż w postaci serduszka", active: true },
]

function Description({theme}) {
  const [value, setValue] = React.useState(0)
  const [data, setData] = useState(fakeData)

  const handleChange = (event, newValue) => {
    setValue(newValue)
  }

  const handleAddDescription = () => {
    if (data.length === 3 ) {
        return
    }

    const newDescription = {
      title: "",
      description: "",
      active: false,
    }

    setData([...data, newDescription])
  }

  return (
    <CenteredCard>
      <Stack spacing={1}>
        <TabContext value={value}>
          <Box sx={{ borderBottom: 1, borderColor: "divider" }}>
            <TabList onChange={handleChange} aria-label='lab API tabs example'>
              {data.map((description, index) => (
                <Tab label={"Opis " + (index + 1)} value={index} key={index} />
              ))}
            </TabList>
          </Box>

          {data.map((description, index) => (
            <TabPanel value={index} key={index} sx={{ width: "500px", background:alpha(theme.palette.background.paper, 0.3) }}>
              <Stack spacing={1}>
                <TextField size='small' variant='filled' id='' label='Tytuł' value={description.title} fullWidth />
                <TextField size='small' multiline rows={5} variant='filled' id='' label='Opis' value={description.description} />
                <Stack spacing={1} direction={"row"}>
                  <Button variant='contained' color='primary'>
                    Zapisz
                  </Button>
                  {!description.active ? (
                    <Button variant='contained' color='success'>
                      Aktywuj
                    </Button>
                  ) : null}
                </Stack>
              </Stack>
            </TabPanel>
          ))}
        </TabContext>

        <Divider />
        <Button variant='contained' color='primary' onClick={handleAddDescription}>
          Dodaj opis
        </Button>
        <Stack spacing={-0.5} sx={{background:alpha(theme.palette.background.paper, 0.3)}}>
          <Typography variant='body1' textAlign={"center"}>
            Możesz mieć maksymalnie 3 opisy.
          </Typography>
          <Typography variant='body1' textAlign={"center"}>
            Konto premium pozwala na korzystanie z 5 opisów.
          </Typography>
        </Stack>
      </Stack>
    </CenteredCard>
  )
}

export default Description
