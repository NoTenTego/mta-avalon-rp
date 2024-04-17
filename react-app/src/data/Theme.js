import { createTheme } from "@mui/material/styles"

export const darkTheme = createTheme({
  palette: {
    mode: "dark",

    background: {
      default: "rgba(0, 0, 0, 0)",
      paper: "rgba(0, 0, 0, 0.8)",
    },

    text: {
      primary: "rgb(255, 255, 255)",
      secondary: "rgb(220, 220, 220)",
      tertiary: "rgb(200, 200, 200)",
    }
  },
})

export const lightTheme = createTheme({
  palette: {
    mode: "light",

    background: {
      default: "rgba(255, 255, 255, 0)",
      paper: "rgba(235, 235, 235, 0.8)",
    },
  },
})
