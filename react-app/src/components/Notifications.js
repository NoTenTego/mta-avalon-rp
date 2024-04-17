import React, { useState, useEffect } from "react"
import Alert from "@mui/material/Alert"
import AlertTitle from "@mui/material/AlertTitle"
import Stack from "@mui/material/Stack"
import { animated, useTransition } from "@react-spring/web"
import { decodeBase64WithPolishCharacters } from "./Utils"

const Notification = () => {
  const [positions, setPositions] = useState({
    maxWidth: 366,
    bottom: 277,
    left: 18,
  })
  const [notifications, setNotifications] = useState([])

  window.clientData = (switchKey, data) => {
    const decodedMessage = decodeBase64WithPolishCharacters(data)

    switch (switchKey) {
      case "notification":
        let { type, title, description } = decodedMessage[0]

        handleNotification(type, title, description)
        break

      case "settings":
        const { maxWidth, bottom, left } = decodedMessage[0]

        setPositions({ maxWidth: maxWidth, bottom: bottom, left: left })
        break

      default:
        break
    }
  }

  useEffect(() => {
    const removeExpiredNotifications = () => {
      setNotifications((prevNotifications) => {
        const now = Date.now()
        return prevNotifications.filter((notification) => {
          return now - notification.displayTime < 15000
        })
      })
    }

    const timer = setInterval(removeExpiredNotifications, 1000)

    return () => clearInterval(timer)
  }, [])

  const handleNotification = (type, title, desc) => {
    if (notifications.length >= 3) {
      return
    }

    const notificationExists = notifications.filter((notification) => {
      return notification.desc === desc;
    });

    if (notificationExists.length > 0) {
      return;
    }

    const newNotification = {
      id: Date.now(),
      type,
      title,
      desc,
      displayTime: Date.now(),
    }

    setNotifications((prevNotifications) => [...prevNotifications, newNotification])
  }

  const transitions = useTransition(notifications, {
    from: { opacity: 0, transform: "translateX(-100%)" },
    enter: { opacity: 1, transform: "translateX(0)" },
    leave: { opacity: 0, transform: "translateX(-100%)" },
    config: { duration: 300 },
  })

  return (
    <Stack
      sx={{
        position: "fixed",
        bottom: String(positions.bottom) + "px",
        left: String(positions.left) + "px",
        zIndex: "10000",
      }}
      spacing={1}>
      {transitions((props, item) =>
        item ? (
          <animated.div style={props} key={item.id} className={`notification ${item.type}`}>
            <Alert
              variant='standard'
              severity={item.type}
              sx={{
                maxWidth: String(positions.maxWidth) + "px",
                width: String(positions.maxWidth) + "px",
                fontSize: "12px",
              }}>
              <AlertTitle>{item.title}</AlertTitle>
              {item.desc}
            </Alert>
          </animated.div>
        ) : null
      )}
    </Stack>
  )
}

export default Notification
