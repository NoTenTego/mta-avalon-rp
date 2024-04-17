import { Routes, Route } from "react-router-dom"
import Hud from "./pages/Hud/Hud"
import Login from "./pages/Accounts/Login"
import CharacterSelection from "./pages/Accounts/CharacterSelection"
import { darkTheme, lightTheme } from "./data/Theme"
import { useEffect, useState } from "react"
import { CssBaseline, ThemeProvider } from "@mui/material"
import Inventory from "./pages/Inventory/Inventory"
import Interior from "./pages/Interior/Interior"
import Vehlib from "./pages/Vehicles/Vehlib"
import Notifications from "./components/Notifications"
import Handling from "./pages/Vehicles/Handling"
import Spawn from "./pages/Vehicles/Spawn"
import Description from "./pages/Hud/Description"
import ChatOOC from "./pages/ChatOOC/Chat"
import Robbery from "./pages/Robbery/Robbery"

function App() {
  const [theme, setTheme] = useState(darkTheme)

  const getScrollbarStyles = (theme) => `
    ::-webkit-scrollbar {
      width: 5px;
      height:5px;
    }

    ::-webkit-scrollbar-track {
      background: rgba(0, 0, 0, 0.2);
    }

    ::-webkit-scrollbar-thumb {
      background: rgba(0, 0, 0, 0.4);
    }

    ::-webkit-scrollbar-thumb:hover {
      background: rgba(0, 0, 0, 0.8);
    }
  `

  useEffect(() => {
    const style = document.createElement("style")
    style.innerHTML = getScrollbarStyles(theme)
    document.getElementsByTagName("head")[0].appendChild(style)

    const cacheTheme = localStorage.getItem("theme")
    if (cacheTheme === "lightTheme") {
      setTheme(lightTheme)
    } else if (cacheTheme === null) {
      setTheme(theme)
    } else {
      setTheme(darkTheme)
    }
  }, [theme])

  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Routes>
        <Route path='/hud' element=<Hud theme={theme} /> />
        <Route path='/description' element=<Description theme={theme} /> />

        <Route path='/loginpanel' element=<Login theme={theme} /> />
        <Route path='/characterselection' element=<CharacterSelection theme={theme} /> />

        <Route path='/inventory' element=<Inventory theme={theme} /> />

        <Route path='/interior' element=<Interior theme={theme} /> />

        <Route path='/vehlib' element=<Vehlib theme={theme} /> />
        <Route path='/handling' element=<Handling theme={theme} /> />
        <Route path='/vehicle/spawn' element=<Spawn theme={theme} /> />

        <Route path='/notifications' element=<Notifications theme={theme} /> />

        <Route path='/chatooc' element=<ChatOOC theme={theme}/> />

        <Route path='/robbery' element=<Robbery/> />
      </Routes>
    </ThemeProvider>
  )
}

export default App
