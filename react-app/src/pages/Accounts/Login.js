import React, { useState } from "react"
import { Box, Card, CardContent, Stack, Typography, TextField, FormControlLabel, Checkbox, useMediaQuery, Button, alpha } from "@mui/material"
import { IconTextField } from "../../components/IconTextField"
import VisibilityIcon from "@mui/icons-material/Visibility"
import VisibilityOffIcon from "@mui/icons-material/VisibilityOff"
import { motion } from "framer-motion"
import { decodeBase64WithPolishCharacters } from "../../components/Utils"

function Login({ theme }) {
  const isSmallScreen = useMediaQuery("(max-width:500px)")

  const [username, setUsername] = useState("")
  const [password, setPassword] = useState({ value: "", visible: false })
  const [rememberMe, setRememberMe] = useState(true)
  const [error, setError] = useState(null)

  const cefData = (switchKey, data) => {
    switch (switchKey) {
      case "UCPLink":
        mta.triggerEvent("accounts:cefData", "UCPLink", "https://avalon-rp.pl")
        break

      case "handleLogin":
        mta.triggerEvent("accounts:cefData", "handleLogin", JSON.stringify({ username: username, password: password.value, rememberMe: rememberMe }))
        break

      default:
        break
    }
  }

  window.clientData = (switchKey, data) => {
    switch (switchKey) {
      case "error":
        setError(data)
        break
      case "accountData":
        const decodedData = decodeBase64WithPolishCharacters(data)

        setUsername(decodedData[0].username)
        setPassword({ value: decodedData[0].password, visible: false })
        break

      default:
        break
    }
  }

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{
        type: "spring",
        stiffness: 260,
        damping: 20,
      }}>
      <Box sx={{ width: "100%", height: "100vh", display: "flex", justifyContent: "center", alignItems: "center", backgroundColor: alpha(theme.palette.background.paper, 0.5) }}>
        <Card sx={{ width: isSmallScreen ? "100%" : "450px" }} elevation={3}>
          <CardContent>
            <Stack>
              <Typography variant='h6'>Witaj na Avalon RP!</Typography>
              <Typography variant='subtitle2' color={"text.secondary"}>
                Zaloguj się na swoje konto i kontynuuj przygodę
              </Typography>
            </Stack>
            <Stack spacing={1.5} mt={3}>
              <TextField
                variant='filled'
                label='Nazwa użytkownika'
                value={username}
                onChange={(event) => {
                  setUsername(event.target.value)
                }}
              />
              <IconTextField
                variant='filled'
                label='Hasło'
                type={password.visible ? null : "password"}
                value={password.value}
                iconEnd={password.visible ? <VisibilityOffIcon /> : <VisibilityIcon />}
                clickFunction={() => {
                  setPassword((prevState) => ({
                    ...prevState,
                    visible: !password.visible,
                  }))
                }}
                onChange={(event) => {
                  setPassword((prevState) => ({
                    ...prevState,
                    value: event.target.value,
                  }))
                }}
              />
              {error ? (
                <Typography variant='body1' color={"error"}>
                  {error}
                </Typography>
              ) : null}
              <FormControlLabel
                label='Zapamiętaj mnie'
                control={
                  <Checkbox
                    checked={rememberMe}
                    onChange={(event) => {
                      setRememberMe(event.target.checked)
                    }}
                    color='primary'
                  />
                }
              />
              <Button
                variant='contained'
                color='primary'
                onClick={() => {
                  cefData("handleLogin")
                }}>
                ZALOGUJ SIĘ
              </Button>
            </Stack>
            <Stack direction={"row"} spacing={2} justifyContent={"center"} alignItems={"center"} mt={3}>
              <Typography variant='body1'>Konto możesz stworzyć na UCP</Typography>
              <Button
                variant='text'
                color='primary'
                onClick={() => {
                  cefData("UCPLink")
                }}>
                Skopiuj Link
              </Button>
            </Stack>
          </CardContent>
        </Card>
      </Box>
    </motion.div>
  )
}

export default Login
