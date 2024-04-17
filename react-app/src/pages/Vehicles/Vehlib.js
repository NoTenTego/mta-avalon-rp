import React from "react"
import { Box, Button, Paper, Stack, Typography, alpha } from "@mui/material"
import { decodeBase64WithPolishCharacters, formatMoney } from "../../components/Utils"
import AddIcon from "@mui/icons-material/Add"
import EditIcon from "@mui/icons-material/Edit"
import DeleteIcon from "@mui/icons-material/DeleteOutlined"
import ElectricCarIcon from "@mui/icons-material/ElectricCar"
import SaveIcon from "@mui/icons-material/Save"
import CancelIcon from "@mui/icons-material/Close"
import {
  DataGrid,
  GridToolbarContainer,
  GridFooterContainer,
  GridToolbarColumnsButton,
  GridToolbarFilterButton,
  GridToolbarDensitySelector,
  plPL,
  GridRowModes,
  GridActionsCellItem,
  GridRowEditStopReasons,
  gridClasses,
} from "@mui/x-data-grid"
import { validModels } from "./data"

function getTimeAgoString(dateString) {
  const date = new Date(dateString)
  const now = new Date()

  const timeDiff = now.getTime() - date.getTime()
  const seconds = Math.floor(timeDiff / 1000)
  const minutes = Math.floor(seconds / 60)
  const hours = Math.floor(minutes / 60)
  const days = Math.floor(hours / 24)

  if (timeDiff < 0) {
    return `przed chwilą`
  }

  if (seconds < 60) {
    return `${seconds} sekund temu`
  } else if (minutes < 60) {
    return `${minutes} minut temu`
  } else if (hours < 24) {
    return `${hours} godzin temu`
  } else {
    return `${days} dni temu`
  }
}

function EditToolbar(props) {
  const { rows, setRows, setRowModesModel } = props

  const handleClick = () => {
    const newId = rows.length === 0 ? 1 : Math.max(...rows.map((row) => row.id)) + 1 // Calculate the new ID
    setRows((oldRows) => [...oldRows, { id: newId, mtaModel: "", mark: "", model: "", year: "", price: "", variant: -1, additional: "", lastUpdate: new Date(), isNew: true }])
    setRowModesModel((oldModel) => ({
      ...oldModel,
      [newId]: { mode: GridRowModes.Edit, fieldToFocus: "mtaModel" },
    }))
  }

  return (
    <GridToolbarContainer>
      <Button color='primary' startIcon={<AddIcon />} onClick={handleClick}>
        Stwórz nowy pojazd
      </Button>
    </GridToolbarContainer>
  )
}

function CustomToolbar(props) {
  return (
    <GridToolbarContainer>
      <EditToolbar {...props} />
      <GridToolbarColumnsButton />
      <GridToolbarFilterButton />
      <GridToolbarDensitySelector />
    </GridToolbarContainer>
  )
}

function CustomFooter(props) {
  return (
    <GridFooterContainer>
      <Typography m={1} variant='body1'>
        Liczba wszystkich pojazdów: {props.rows.length}
      </Typography>
    </GridFooterContainer>
  )
}

const fakeData = [
  {
    id: 1,
    mtaModel: "Model1",
    mark: "Marka1",
    model: "Model1",
    year: "2022",
    price: "25000",
    variant: 1,
    additional: "Dodatkowe informacje 1",
    lastUpdate: new Date(),
    isNew: false,
  },
  {
    id: 2,
    mtaModel: "Model2",
    mark: "Marka2",
    model: "Model2",
    year: "2023",
    price: "28000",
    variant: 2,
    additional: "Dodatkowe informacje 2",
    lastUpdate: new Date(),
    isNew: false,
  },

]

function Vehlib({ theme }) {
  const [rows, setRows] = React.useState([])
  const [rowModesModel, setRowModesModel] = React.useState({})

  const cefData = (switchKey, data) => {
    switch (switchKey) {
      case "sendNotification":
        mta.triggerEvent("hud:sendNotification", "Biblioteka pojazdów", data)
        break
      case "toggleVehlib":
        mta.triggerEvent("vehicle-system:toggleVehlib")
        break
      case "deleteVehicle":
        mta.triggerEvent("vehicle-system:cefData", "deleteVehicle", data)
        break
      case "editHandling":
        mta.triggerEvent("vehicle-system:cefData", "editHandling", data)
        break
      case "makeVehicle":
        let makePrice = data.price
        makePrice = makePrice.replace(/\$|,/g, "")

        let dataJsonMake = JSON.stringify({
          mta_model: data.mtaModel,
          brand: data.mark,
          model: data.model,
          year: data.year,
          price: Number(makePrice),
          variant: data.variant,
          additional: data.additional,
        })

        mta.triggerEvent("vehicle-system:cefData", "makeVehicle", dataJsonMake)
        break
      case "editVehicle":
        let editPrice = data.price
        editPrice = editPrice.replace(/\$|,/g, "")

        let dataJsonEdit = JSON.stringify({
          id: data.id,
          mta_model: data.mtaModel,
          brand: data.mark,
          model: data.model,
          year: data.year,
          price: Number(editPrice),
          variant: data.variant,
          additional: data.additional,
        })

        mta.triggerEvent("vehicle-system:cefData", "editVehicle", dataJsonEdit)
        break
      default:
        break
    }
  }

  window.clientData = (data) => {
    const decodedData = decodeBase64WithPolishCharacters(data)

    setRows(decodedData[0])
  }

  const handleRowEditStop = (params, event) => {
    if (params.reason === GridRowEditStopReasons.rowFocusOut) {
      event.defaultMuiPrevented = true
    }
  }

  const handleEditClick = (id) => () => {
    setRowModesModel({ ...rowModesModel, [id]: { mode: GridRowModes.Edit } })
  }

  const handleSaveClick = (id) => () => {
    setRowModesModel({ ...rowModesModel, [id]: { mode: GridRowModes.View } })
  }

  const handleHandlingClick = (id) => () => {
    cefData("editHandling", id)
  }

  const handleDeleteClick = (id) => () => {
    cefData("deleteVehicle", id)

    setRows((oldRows) => oldRows.filter((row) => row.id !== id))
  }

  const handleCancelClick = (id) => () => {
    const editedRow = rows.find((row) => row.id === id)
    if (editedRow.isNew === true) {
      setRows((oldRows) => oldRows.filter((row) => row.id !== id))

      const updatedModel = { ...rowModesModel }
      delete updatedModel[id]
      setRowModesModel(updatedModel)
    }

    if (rowModesModel[id]?.isNew) {
      setRows((oldRows) => oldRows.filter((row) => row.id !== id))
    }

    setRowModesModel({
      ...rowModesModel,
      [id]: { mode: GridRowModes.View, ignoreModifications: true },
    })
  }

  const processRowUpdate = (newRow) => {
    if (newRow.mark.length < 2 || newRow.model.length < 2 || String(newRow.year.length) < 2 || String(newRow.price.length) < 1 || String(newRow.mtaModel.length) < 2 || String(newRow.variant.length) < 1) {
      cefData("sendNotification", "Każde pole oprócz dodatków musi być uzupełnione.")
      return
    }

    if (!validModels.some((model) => Number(model) === Number(newRow.mtaModel))) {
      cefData("sendNotification", "Nie znaleziono modelu o numerze " + newRow.mtaModel)
      return
    }

    if (newRow.isNew === true) {
      cefData("makeVehicle", newRow)
    } else {
      cefData("editVehicle", newRow)
    }

    const updatedRow = { ...newRow, isNew: false, lastUpdate: new Date() }
    setRows((oldRows) => oldRows.map((row) => (row.id === newRow.id ? updatedRow : row)))
    return updatedRow
  }

  const handleRowModesModelChange = (newRowModesModel) => {
    setRowModesModel(newRowModesModel)
  }

  const columns = [
    { field: "id", headerName: "ID" },
    { field: "mtaModel", headerName: "MTA Model", width: 100, editable: true },
    { field: "mark", headerName: "Marka", width: 150, editable: true },
    { field: "model", headerName: "Model", width: 150, editable: true },
    { field: "year", headerName: "Rok", editable: true },
    { field: "price", headerName: "Cena", editable: true, valueGetter: (params) => formatMoney(params.row.price) },
    { field: "variant", headerName: "Wariant", width: 75, editable: true },
    { field: "additional", headerName: "Dodatki", width: 100, editable: true },
    { field: "lastUpdate", headerName: "Aktualizacja", width: 150, valueGetter: (params) => getTimeAgoString(params.row.lastUpdate) },
    {
      field: "actions",
      type: "actions",
      headerName: "Funkcje",
      width: 150,
      cellClassName: "actions",
      getActions: ({ id }) => {
        const isInEditMode = rowModesModel[id]?.mode === GridRowModes.Edit

        if (isInEditMode) {
          return [
            <GridActionsCellItem
              icon={<SaveIcon />}
              label='Save'
              sx={{
                color: "primary.main",
              }}
              onClick={handleSaveClick(id)}
            />,
            <GridActionsCellItem icon={<CancelIcon />} label='Cancel' className='textPrimary' onClick={handleCancelClick(id)} color='inherit' />,
          ]
        }

        return [
          <GridActionsCellItem icon={<EditIcon />} label='Edit' className='textPrimary' onClick={handleEditClick(id)} color='inherit' />,
          <GridActionsCellItem icon={<DeleteIcon />} label='Delete' onClick={handleDeleteClick(id)} color='error' />,
          <GridActionsCellItem icon={<ElectricCarIcon />} label='Handling' onClick={handleHandlingClick(id)} color='inherit' />,
        ]
      },
    },
  ]

  return (
    <Stack spacing={1} sx={{ position: "absolute", left: "50%", top: "50%", transform: "translate(-50%, -50%)", padding: "1rem", backgroundColor: "rgba(0, 0, 0, 0.7)" }}>
      <Stack direction={"row"} spacing={1} justifyContent={"space-between"} alignItems={"center"}>
        <Typography variant='body1'>Lista pojazdów dostępnych we wszystkich sklepach biznesowych</Typography>
        <Button
          variant='outlined'
          color='error'
          onClick={() => {
            cefData("toggleVehlib")
          }}>
          Wyjdź
        </Button>
      </Stack>
      <Box sx={{ height: "50vh" }} component={Paper}>
        <DataGrid
          sx={{
            [`& .${gridClasses.row}.even`]: {
              backgroundColor: alpha(theme.palette.background.paper, 0.2),

              "&:hover": { backgroundColor: alpha(theme.palette.background.paper, 0.2) },
            },
            [`& .${gridClasses.row}:hover`]: {
              backgroundColor: "unset",
            },
          }}
          rows={rows}
          columns={columns}
          disableRowSelectionOnClick
          disableColumnMenu
          localeText={plPL.components.MuiDataGrid.defaultProps.localeText}
          editMode='row'
          rowModesModel={rowModesModel}
          onRowModesModelChange={handleRowModesModelChange}
          onRowEditStop={handleRowEditStop}
          processRowUpdate={processRowUpdate}
          onProcessRowUpdateError={() => {}}
          getRowClassName={(params) => (params.indexRelativeToCurrentPage % 2 === 0 ? "even" : "odd")}
          slots={{
            toolbar: CustomToolbar,
            footer: CustomFooter,
          }}
          slotProps={{
            toolbar: { rows, setRows, setRowModesModel },
            footer: { rows },
          }}
          initialState={{
            columns: {
              columnVisibilityModel: {
                lastUpdate: false,
              },
            },
          }}
        />
      </Box>
    </Stack>
  )
}

export default Vehlib
