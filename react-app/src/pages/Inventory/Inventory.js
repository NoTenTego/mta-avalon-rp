import * as React from "react"
import PropTypes from "prop-types"
import Tabs from "@mui/material/Tabs"
import Tab from "@mui/material/Tab"
import Typography from "@mui/material/Typography"
import { Card, IconButton, Stack, alpha } from "@mui/material"
import PlayCircleIcon from "@mui/icons-material/PlayCircle"
import HighlightOffIcon from "@mui/icons-material/HighlightOff"
import ItemMenu from "./ItemMenu"
import { decodeBase64WithPolishCharacters } from "../../components/Utils"

function TabPanel({ children, value, index, items, cefData, theme }) {
  const filteredItems = Array.isArray(items)
    ? items.filter((item) => {
        if (index === 0) {
          return item[6] === 1
        } else if (index === 1) {
          return item[6] === 2
        } else if (index === 2) {
          return item[6] === 3
        }
        return false
      })
    : []

  return (
    <div role='tabpanel' hidden={value !== index} id={`vertical-tabpanel-${index}`} aria-labelledby={`vertical-tab-${index}`}>
      {value === index && (
        <div>
          <Stack direction={"row"} spacing={5} sx={{ padding: "1rem", paddingBottom: ".76rem", paddingTop: ".76rem" }} justifyContent={"space-between"} alignItems={"center"}>
            <Typography variant='body1' sx={{ width: "35%" }} color={"primary"}>
              Nazwa
            </Typography>
            <Stack direction={"row"} spacing={2}>
              <Typography variant='body1' color={"primary"}>
                Wartość 1
              </Typography>
              <Typography variant='body1' color={"primary"}>
                Wartość 2
              </Typography>
            </Stack>
            <Stack direction={"row"} spacing={0.1} justifyContent='flex-end' sx={{ width: "20%" }}>
              <IconButton
                aria-label='closeInventory'
                onClick={() => {
                  cefData("closeInventory")
                }}>
                <HighlightOffIcon />
              </IconButton>
            </Stack>
          </Stack>
          <Card sx={{ minWidth: "650px", maxHeight: "400px", overflowY: "auto" }}>
            {filteredItems.map((item, index) => (
              <Stack spacing={0.5} key={item[4]}>
                <Stack
                  direction={"row"}
                  spacing={5}
                  alignItems={"center"}
                  justifyContent={"space-between"}
                  sx={{ backgroundColor: index % 2 ? alpha(theme.palette.background.default, 0.3) : null, padding: ".2rem", paddingLeft: "1rem", paddingRight: "1rem" }}>
                  <Typography variant='body1' sx={{ width: "35%" }}>
                    {item[0]}
                  </Typography>
                  <Stack direction={"row"} spacing={2}>
                    <Typography variant='body1'>{item[1]}</Typography>
                    <Typography variant='body1'>{item[2]}</Typography>
                  </Stack>
                  <Stack direction={"row"} spacing={0.1} justifyContent='flex-end' sx={{ width: "20%" }}>
                    <IconButton
                      aria-label='useItem'
                      onClick={() => {
                        cefData("useItem", item)
                      }}>
                      <PlayCircleIcon />
                    </IconButton>
                    <ItemMenu item={item} cefData={cefData} />
                  </Stack>
                </Stack>
              </Stack>
            ))}
          </Card>
          <Typography variant='body1' sx={{ padding: ".5rem" }} color={"text.secondary"}>
            Waga przedmiotów: {filteredItems.length} lbs
          </Typography>
        </div>
      )}
    </div>
  )
}

TabPanel.propTypes = {
  children: PropTypes.node,
  index: PropTypes.number.isRequired,
  value: PropTypes.number.isRequired,
}

function a11yProps(index) {
  return {
    id: `vertical-tab-${index}`,
    "aria-controls": `vertical-tabpanel-${index}`,
  }
}

export default function Inventory({ theme }) {
  const [items, setItems] = React.useState([])
  const [value, setValue] = React.useState(1)

  const handleChange = (event, newValue) => {
    setValue(newValue)
  }

  const cefData = (switchKey, data) => {
    let dataJson = undefined
    if (data) {
      dataJson = JSON.stringify({
        name: data[0],
        value1: data[1],
        value2: data[2],
        itemID: data[3],
        id: data[4],
        owner: data[5],
        category: data[6],
        additional: data[7],
      })
    }

    switch (switchKey) {
      case "closeInventory":
        mta.triggerEvent("inventory:client", "closeInventory")
        break
      case "useItem":
        mta.triggerEvent("inventory:client", "useItem", dataJson)
        break
      case "deleteItem":
        mta.triggerEvent("inventory:client", "deleteItem", dataJson)
        break

      default:
        break
    }
  }

  window.clientData = (switchKey, data) => {
    switch (switchKey) {
      case "items":
        const decodedData = decodeBase64WithPolishCharacters(data)

        setItems(decodedData[0])
        break

      default:
        break
    }
  }

  return (
    <Card sx={{ flexGrow: 1, display: "flex", position: "absolute", left: "50%", top: "50%", transform: "translate(-50%, -50%)" }}>
      <Tabs orientation='vertical' value={value} onChange={handleChange} aria-label='Vertical tabs example' sx={{ borderRight: 1, borderColor: "divider" }}>
        <Tab label='Portfel' {...a11yProps(0)} />
        <Tab label='Przedmioty' {...a11yProps(1)} />
        <Tab label='Bronie' {...a11yProps(2)} />
      </Tabs>
      <TabPanel value={value} index={0} items={items} cefData={cefData} theme={theme} />
      <TabPanel value={value} index={1} items={items} cefData={cefData} theme={theme} />
      <TabPanel value={value} index={2} items={items} cefData={cefData} theme={theme} />
    </Card>
  )
}
