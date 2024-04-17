import { Typography, Stack, TextField, CardContent, IconButton, InputAdornment, CardActionArea } from "@mui/material"
import React, { useEffect, useRef, useState } from "react"
import { decodeBase64WithPolishCharacters } from "../../components/Utils"
import VisibilityIcon from "@mui/icons-material/Visibility"
import VisibilityOffIcon from "@mui/icons-material/VisibilityOff"

const commands = [
  { name: "/me", description: "Narracja In Character", type: "IC", arguments: ["opis czynności"] },
  { name: "/do", description: "Narracja In Character", type: "IC", arguments: ["opis otoczenia"] },
  { name: "/s", description: "Szept", type: "IC", arguments: ["tekst"] },
  { name: "/k", description: "Krzyk", type: "IC", arguments: ["tekst"] },
  { name: "/ooc", description: "Chat Out Of Character", type: "OOC", arguments: ["tekst"] },
  { name: "/togglechat", description: "Przełączenie pokazywania chatu", type: "Komenda" },
  { name: "/toggleooc", description: "Przełączenie pokazywania chatu OOC", type: "Komenda" },
]

function ChatOOC({ theme }) {
  const [config, setConfig] = useState(null)
  const [chatOOCMessages, setChatOOCMessages] = useState([])
  const [chatICMessages, setChatICMessages] = useState([])

  const [textInput, setTextInput] = useState("")
  const [textInputHistory, setTextInputHistory] = useState({ index: -1, history: [] })
  const [textInputActive, setTextInputActive] = useState(false)

  const [showCommands, setShowCommands] = useState(true)
  const [oocActive, setOocActive] = useState(true)

  const messagesEndRefIC = useRef(null)
  const messagesEndRefOOC = useRef(null)

  useEffect(() => {
    messagesEndRefIC.current?.scrollIntoView({ behavior: "smooth" })
  }, [chatICMessages])

  useEffect(() => {
    messagesEndRefOOC.current?.scrollIntoView({ behavior: "smooth" })
  }, [chatOOCMessages])

  const handleKeyUp = (event) => {
    switch (event.key) {
      case "Enter":
        setTextInputHistory((prevState) => ({
          ...prevState,
          history: [...prevState.history, textInput],
        }))

        cefData(textInput[0] === "/" ? "command" : "ic")
        setTextInputActive(false)
        setTextInput("")
        break

      case "ArrowDown":
        if (textInputHistory.history.length >= 0) {
          const newIndex = Math.max(-1, textInputHistory.index - 1)
          const isTextInHistory = textInputHistory.history[newIndex]
          if (isTextInHistory) {
            setTextInput(isTextInHistory || "")
            setTextInputHistory((prevState) => ({
              ...prevState,
              index: newIndex,
            }))
          } else {
            setTextInput("")
            setTextInputHistory((prevState) => ({
              ...prevState,
              index: -1,
            }))
          }
        }
        break

      case "ArrowUp":
        if (textInputHistory.history.length >= 0) {
          const newIndex = Math.min(textInputHistory.index + 1, textInputHistory.history.length)
          const isTextInHistory = textInputHistory.history[newIndex]
          if (isTextInHistory) {
            setTextInput(isTextInHistory || "")
            setTextInputHistory((prevState) => ({
              ...prevState,
              index: newIndex,
            }))
          }
        }
        break

      default:
        break
    }
  }

  window.clientData = (chat, name, data) => {
    try {
      if (chat === "ooc") {
        switch (name) {
          case "message":
            const decodedMessage = decodeBase64WithPolishCharacters(data)

            setChatOOCMessages((prevMessages) => {
              const updatedMessages = [...prevMessages, decodedMessage[0]]

              if (updatedMessages.length > 50) {
                updatedMessages.shift()
              }

              return updatedMessages
            })
            break
          case "deleteMessages":
            setChatOOCMessages([])
            break
          default:
            break
        }
      } else if (chat === "config") {
        switch (name) {
          case "config":
            setConfig(JSON.parse(data)[0])
            break
          case "inputActive":
            setTextInputActive(JSON.parse(data)[0])
            setTextInput("")
            setTextInputHistory((prevState) => ({
              ...prevState,
              index: -1,
            }))
            break
          case "oocActive":
            setOocActive(!oocActive)
            break

          default:
            break
        }
      } else if (chat === "ic") {
        switch (name) {
          case "message":
            const decodedMessage = decodeBase64WithPolishCharacters(data)

            setChatICMessages((prevMessages) => {
              const updatedMessages = [...prevMessages, decodedMessage[0]]

              if (updatedMessages.length > 50) {
                updatedMessages.shift()
              }

              return updatedMessages
            })
            break
          case "deleteMessages":
            setChatICMessages([])
            break
          default:
            break
        }
      }
    } catch (error) {
      console.error("Error processing clientData:", error)
    }
  }

  const cefData = (key) => {
    switch (key) {
      case "ic":
        mta.triggerEvent("chat-system:cefData", "ic", textInput)
        break
      case "command":
        let message = textInput
        let words = message.split(" ")
        let command = words.shift().replace("/", "")
        let restMessage = words.join(" ")

        mta.triggerEvent("chat-system:cefData", "command", JSON.stringify({ command: command, arguments: [restMessage] }))
        break
      default:
        break
    }
  }

  if (!config) {
    return null
  }

  return (
    <Stack spacing={3} sx={{ marginLeft: `${config.chat_position_offset_x * 100}%`, marginTop: `${config.chat_position_offset_y * 100}vh` }}>
      <Stack sx={{ maxWidth: 300 * config.chat_width * ((config.chat_scale[0] + config.chat_scale[1]) / 2) }}>
        <Stack
          spacing={0.9}
          sx={{
            height: "250px",
            overflowY: "scroll",
            "::-webkit-scrollbar": {
              display: "none",
            },
          }}
        >
          {chatICMessages.map((message, index) => (
            <Typography
              key={index}
              variant='subtitle1'
              color='initial'
              sx={{
                fontWeight: "bold",
                fontFamily: "Roboto, sans-serif",
                color: "rgb(230, 230, 230)",
                textShadow: "1.2px 1.2px 1px rgba(0, 0, 0, 1)",
                fontSize: 13 * ((config.chat_scale[0] + config.chat_scale[1]) / 2),
                lineHeight: 1.1,
                ...message.additional,
              }}
            >
              {message.message}
            </Typography>
          ))}
          <div ref={messagesEndRefIC} />
        </Stack>
      </Stack>
      <Stack spacing={0.5}>
        <TextField
          id='textBox'
          label={textInput[0] === "/" ? "Komenda" : "IC"}
          variant='filled'
          value={textInput}
          onChange={(event) => {
            setTextInput(event.target.value)
          }}
          onKeyDown={(event) => {
            handleKeyUp(event)
          }}
          InputProps={{
            endAdornment: (
              <InputAdornment position='end'>
                <IconButton disableRipple onClick={() => setShowCommands(!showCommands)} edge='end'>
                  {showCommands ? <VisibilityOffIcon /> : <VisibilityIcon />}
                </IconButton>
              </InputAdornment>
            ),
          }}
          autoFocus
          inputRef={(input) => input?.focus()}
          sx={{
            "& .MuiInputBase-input": {
              borderRadius: "2px",
            },
            backgroundColor: "rgb(0, 0, 0, 0.5)",
            width: 300 * config.chat_width * ((config.chat_scale[0] + config.chat_scale[1]) / 2),
            visibility: textInputActive ? "visible" : "hidden",
            borderRadius: "2px",
          }}
        />
        {textInput[0] === "/" && showCommands && (
          <Stack
            spacing={0.5}
            sx={{
              maxHeight: "267px",
              width: 300 * config.chat_width * ((config.chat_scale[0] + config.chat_scale[1]) / 2),
              overflowY: "scroll",
              "::-webkit-scrollbar": {
                display: "none",
              },
            }}
          >
            {commands
              .filter((command, index) => command.name.includes(textInput.split(" ").shift()))
              .map((command, index) => (
                <CardContent key={index} sx={{ backgroundColor: "rgb(0, 0, 0, 0.5)", borderRadius: "2px", padding: "0", height: "70px" }}>
                  <CardActionArea
                    onClick={() => {
                      setTextInput(command.name + " ")
                    }}
                  >
                    <Stack spacing={0.5} justifyContent={"center"} sx={{ padding: ".5rem" }}>
                      <Stack direction={"row"} spacing={1} alignItems={"center"}>
                        <Typography variant='subtitle1'>{command.name}</Typography>
                        {command.arguments &&
                          command.arguments.map((argument, index) => (
                            <Typography key={index} variant='subtitle1' sx={{ backgroundColor: "rgb(0, 0, 0, 0.5)", padding: "0 .4rem", borderRadius: "2px", fontSize: 10 * ((config.chat_scale[0] + config.chat_scale[1]) / 2) }}>
                              {argument}
                            </Typography>
                          ))}
                        {command.optionalArguments &&
                          command.optionalArguments.map((argument, index) => (
                            <Typography key={index} variant='subtitle1' sx={{ backgroundColor: "rgb(0, 0, 0, 0.2)", padding: "0 .4rem", borderRadius: "2px", fontSize: 10 * ((config.chat_scale[0] + config.chat_scale[1]) / 2) }}>
                              {argument}
                            </Typography>
                          ))}
                      </Stack>

                      <Stack direction={"row"} spacing={1}>
                        <Typography variant='caption' color={"text.secondary"}>
                          {command.description}
                        </Typography>
                      </Stack>
                    </Stack>
                  </CardActionArea>
                </CardContent>
              ))}
          </Stack>
        )}
      </Stack>
      {!(textInput[0] === "/" && showCommands) && oocActive && (
        <Stack spacing={1}>
          <Stack direction={"row"} spacing={1}>
            <Typography
              variant='subtitle1'
              sx={{ fontWeight: "bold", color: "rgb(200, 200, 200)", fontFamily: "Roboto, sans-serif", textShadow: "1.2px 1px 1px rgba(0, 0, 0, 1)", fontSize: 13 * ((config.chat_scale[0] + config.chat_scale[1]) / 2) }}
            >
              Chat OOC - (aby przełączyć /toggleooc)
            </Typography>
          </Stack>
          <Stack
            spacing={0.9}
            sx={{
              maxWidth: 300 * config.chat_width * ((config.chat_scale[0] + config.chat_scale[1]) / 2),
              height: "160px",
              overflowY: "scroll",
              "::-webkit-scrollbar": {
                display: "none",
              },
            }}
          >
            {chatOOCMessages.map((message, index) => (
              <Typography
                key={index}
                variant='subtitle1'
                color='initial'
                sx={{
                  fontWeight: "bold",
                  fontFamily: "Roboto, sans-serif",
                  color: "rgb(230, 230, 230)",
                  textShadow: "1.2px 1.2px 1px rgba(0, 0, 0, 1)",
                  fontSize: 13 * ((config.chat_scale[0] + config.chat_scale[1]) / 2),
                  lineHeight: 1.1,
                  ...message.additional,
                }}
              >
                {message.before && <span dangerouslySetInnerHTML={{ __html: message.before }} />} {message.message} {message.after && <span dangerouslySetInnerHTML={{ __html: message.after }} />}
              </Typography>
            ))}
            <div ref={messagesEndRefOOC} />
          </Stack>
        </Stack>
      )}
    </Stack>
  )
}

export default ChatOOC
