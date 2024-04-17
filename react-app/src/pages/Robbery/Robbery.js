import { CssBaseline, ThemeProvider, Stepper, Button, StepLabel, Step, Card, CardContent, CardMedia, Typography, Stack, CardActionArea, alpha, Rating, Alert } from "@mui/material"
import { useState } from "react"
import TransferList from "./TransferList"
import { formatMoney } from "../../components/Utils"
import CenteredCard from "../../components/CenteredCard"
import { darkTheme } from "../../data/Theme"

function Robbery() {
  const [theme, setTheme] = useState(darkTheme)

  const [config, setConfig] = useState({
    steps: ["Wybierz napad", "Dodaj członków", "Podsumowanie"],
    robberies: [
      {
        id: 1,
        name: "Operacja Barka",
        image: "http://mta/cef/assets/images/robberies/robbery-1.png",
        description: "Twój zespół planuje napad na lokalny bar alkoholowy, aby ukraść gotówkę z kasy oraz najcenniejsze alkohole. Musisz działać szybko, zanim ktoś wezwie policję, ale także unikać awantur i przyciągania zbyt dużej uwagi.",
        settings: {
          difficulty: 3,
          payday: [4000, 9000],
          shopItems: ["Alarm", "Kamery", "Sejf", "Uzbrojony pracownik"],
          suggestedItems: ["Torba", "Kominiarka", "Broń palna"],
          additionalDescription:
            "Napad ma określony czas. Jeśli nie uda ci się zrealizować swojego planu w określonym czasie, możliwość okradania miejsca zostanie utracona, a jedyną opcją będzie ucieczka. Ważne jest, aby być szybkim, sprytnym i elastycznym, aby dostosować się do zmieniającej się sytuacji. Dodatkowo, podczas napadu możesz także szukać wartościowych przedmiotów lub przeszukiwać miejsca takie jak sejfy.",
        },
      },
      {
        id: 2,
        name: "Skok na Zastaw",
        image: "http://mta/cef/assets/images/robberies/robbery-2.png",
        description: "Twoim celem jest napad na lombard, aby ukraść cenne przedmioty zastawione przez klientów. Musisz obejść systemy zabezpieczeń i unikać zwracania uwagi obsługi lombardu oraz klientów, którzy mogą być podejrzliwi.",
        settings: {
          difficulty: 5,
          payday: [4000, 9000],
          shopItems: ["Alarm", "Kamery", "Sejf", "Uzbrojony pracownik"],
          suggestedItems: ["Torba", "Kominiarka", "Broń palna"],
          additionalDescription:
            "Napad ma określony czas. Jeśli nie uda ci się zrealizować swojego planu w określonym czasie, możliwość okradania miejsca zostanie utracona, a jedyną opcją będzie ucieczka. Ważne jest, aby być szybkim, sprytnym i elastycznym, aby dostosować się do zmieniającej się sytuacji. Dodatkowo, podczas napadu możesz także szukać wartościowych przedmiotów lub przeszukiwać miejsca takie jak sejfy.",
        },
      },
      {
        id: 3,
        name: "Operacja McNapad",
        image: "http://mta/cef/assets/images/robberies/robbery-3.png",
        description:
          "Twój zespół planuje napad na restaurację McDonald's, aby ukraść gotówkę z kasy oraz zaopatrzenie restauracji. Musisz działać sprytnie, unikając wykrycia przez personel i klientów oraz zapobiegając zbyt dużemu hałasowi, który mógłby przyciągnąć uwagę policji.",
        settings: {
          difficulty: 5,
          payday: [4000, 9000],
          shopItems: ["Alarm", "Kamery", "Sejf", "Uzbrojony pracownik"],
          suggestedItems: ["Torba", "Kominiarka", "Broń palna"],
          additionalDescription:
            "Napad ma określony czas. Jeśli nie uda ci się zrealizować swojego planu w określonym czasie, możliwość okradania miejsca zostanie utracona, a jedyną opcją będzie ucieczka. Ważne jest, aby być szybkim, sprytnym i elastycznym, aby dostosować się do zmieniającej się sytuacji. Dodatkowo, podczas napadu możesz także szukać wartościowych przedmiotów lub przeszukiwać miejsca takie jak sejfy.",
        },
      },
    ],
    groupPlayers: [],
  })

  const [currentConfig, setCurrentConfig] = useState({
    robbery: null,
  })

  const [activeStep, setActiveStep] = useState(0)

  const handleNext = () => {
    if (activeStep === 0 && currentConfig.robbery === null) {
      return
    }

    setActiveStep((prevActiveStep) => prevActiveStep + 1)
  }

  const handleBack = () => {
    setActiveStep((prevActiveStep) => prevActiveStep - 1)
  }

  window.clientData = (name, data) => {
    try {
    } catch (error) {
      console.error("Error processing clientData:", error)
    }
  }

  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <CenteredCard style={{ display: "flex", justifyContent: "center", flexDirection: "column", alignItems: "center", minWidth: "900px" }}>
        <Stepper activeStep={activeStep} alternativeLabel sx={{ minWidth: "500px", marginBottom: "15px" }}>
          {config.steps.map((step, index) => (
            <Step key={index}>
              <StepLabel>{step}</StepLabel>
            </Step>
          ))}
        </Stepper>

        {activeStep === 0 ? (
          <>
            <Alert severity='info' variant='filled' sx={{ marginBottom: "10px", backgroundColor: alpha(theme.palette.background.paper, 0.5), color: "text.secondary" }}>
              W ciągu 24 godzin możliwe jest przeprowadzenie tylko jednego napadu, który może być zainicjowany wyłącznie przez lidera organizacji. Wykorzystaj tę zasadę do starannego planowania i koordynowania działań, aby maksymalnie
              wykorzystać potencjał grupy oraz minimalizować ryzyko.
            </Alert>
            <Stack direction={"row"} spacing={1}>
              {config.robberies.map((robbery, index) => (
                <Card key={index} sx={{ minWidth: "300px", backgroundColor: currentConfig.robbery === robbery.id && alpha(theme.palette.primary.dark, 0.5) }}>
                  <CardActionArea
                    onClick={() => {
                      setCurrentConfig((prevState) => ({
                        ...prevState,
                        robbery: robbery.id,
                      }))
                    }}>
                    <CardMedia component='img' height='180' image={robbery.image} alt={robbery.name} />
                    <CardContent>
                      <Typography gutterBottom variant='h5' component='div'>
                        {robbery.name}
                      </Typography>
                      <Typography variant='body2' color='text.secondary'>
                        {robbery.description}
                      </Typography>
                    </CardContent>
                  </CardActionArea>
                </Card>
              ))}
            </Stack>
          </>
        ) : activeStep === 1 ? (
          <TransferList />
        ) : (
          <Stack spacing={0.5} direction={"row"} sx={{ width: "916px", height: "392px" }}>
            <Card sx={{ width: "300px", borderTopRightRadius: 0, borderBottomRightRadius: 0 }}>
              <CardActionArea>
                <CardMedia component='img' height='180' image={config.robberies[currentConfig.robbery - 1].image} alt={config.robberies[currentConfig.robbery - 1].name} />
                <CardContent>
                  <Typography gutterBottom variant='h5' component='div'>
                    {config.robberies[currentConfig.robbery - 1].name}
                  </Typography>
                  <Typography variant='body2' color='text.secondary'>
                    {config.robberies[currentConfig.robbery - 1].description}
                  </Typography>
                </CardContent>
              </CardActionArea>
            </Card>
            <Card sx={{ borderTopLeftRadius: 0, borderBottomLeftRadius: 0 }}>
              <CardContent>
                <Stack spacing={2} sx={{ width: "580px" }} justifyContent={"center"}>
                  <Stack direction={"row"} spacing={2} justifyContent={"space-between"}>
                    <Stack spacing={0.25}>
                      <Typography variant='caption' color='text.secondary'>
                        Potencjalny zarobek
                      </Typography>
                      <Typography variant='button' sx={{ padding: ".2rem .4rem", backgroundColor: "rgba(0, 255, 0, 0.2)", borderRadius: "5px", width: "fit-content" }}>
                        {formatMoney(config.robberies[currentConfig.robbery - 1].settings.payday[0]) + " - " + formatMoney(config.robberies[currentConfig.robbery - 1].settings.payday[1])}
                      </Typography>
                    </Stack>
                    <Stack spacing={0.25}>
                      <Typography variant='caption' color='text.secondary'>
                        Poziom trudności
                      </Typography>
                      <Rating name='read-only' value={config.robberies[currentConfig.robbery - 1].settings.difficulty} precision={0.5} readOnly />
                    </Stack>
                  </Stack>
                  <Stack spacing={0.5}>
                    <Typography variant='caption' color='text.secondary'>
                      Sklep posiada
                    </Typography>

                    <Stack direction={"row"} spacing={1}>
                      {config.robberies[currentConfig.robbery - 1].settings.shopItems.map((shopItem, index) => (
                        <Typography key={index} variant='button' sx={{ padding: ".2rem .4rem", backgroundColor: "rgba(255, 0, 0, 0.2)", borderRadius: "5px", width: "fit-content" }}>
                          {shopItem}
                        </Typography>
                      ))}
                    </Stack>
                  </Stack>
                  <Stack spacing={0.5}>
                    <Typography variant='caption' color='text.secondary'>
                      Proponowane wyposażenie
                    </Typography>

                    <Stack direction={"row"} spacing={1}>
                      {config.robberies[currentConfig.robbery - 1].settings.suggestedItems.map((suggestedItem, index) => (
                        <Typography variant='button' sx={{ padding: ".2rem .4rem", backgroundColor: "rgba(255, 0, 0, 0.2)", borderRadius: "5px", width: "fit-content" }}>
                          {suggestedItem}
                        </Typography>
                      ))}
                    </Stack>
                  </Stack>
                  <Stack spacing={0.5}>
                    <Typography variant='caption' color='text.secondary'>
                      dodatkowe informacje
                    </Typography>

                    <Typography variant='subtitle2' color='text.secondary'>
                      {config.robberies[currentConfig.robbery - 1].settings.additionalDescription}
                    </Typography>
                  </Stack>
                </Stack>
              </CardContent>
            </Card>
          </Stack>
        )}
        <Stack direction={"row"} spacing={1} justifyContent={"flex-end"} mt={2} sx={{ width: "100%" }}>
          <Button variant='outlined' onClick={handleBack} disabled={activeStep === 0}>
            {activeStep === 0 ? "Anuluj" : config.steps[activeStep - 1]}
          </Button>
          {activeStep === config.steps.length - 1 ? (
            <Button disabled={activeStep >= config.steps.length} variant='contained' onClick={handleNext}>
              Rozpocznij napad
            </Button>
          ) : (
            <Button disabled={activeStep >= config.steps.length} variant='contained' onClick={handleNext}>
              Dalej
            </Button>
          )}
        </Stack>
      </CenteredCard>
    </ThemeProvider>
  )
}

export default Robbery
