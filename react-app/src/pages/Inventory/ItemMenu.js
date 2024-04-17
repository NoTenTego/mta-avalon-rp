import { useState } from "react"
import Menu from "@mui/material/Menu"
import MenuItem from "@mui/material/MenuItem"
import Divider from "@mui/material/Divider"
import Typography from "@mui/material/Typography"
import { IconButton, ListItemIcon, ListItemText, Stack } from "@mui/material"
import MoreVertIcon from "@mui/icons-material/MoreVert"
import TransferWithinAStationIcon from "@mui/icons-material/TransferWithinAStation"
import DeleteIcon from "@mui/icons-material/Delete"
import LocationSearchingIcon from "@mui/icons-material/LocationSearching"

export default function ItemMenu({ item, cefData }) {
  const [anchorEl, setAnchorEl] = useState(null)
  const open = Boolean(anchorEl)

  const handleClick = (event) => {
    setAnchorEl(event.currentTarget)
  }

  const handleClose = () => {
    setAnchorEl(null)
  }

  return (
    <>
      <IconButton aria-label='moreItemInfo' onClick={handleClick}>
        <MoreVertIcon />
      </IconButton>
      <Menu
        anchorEl={anchorEl}
        id='account-menu'
        open={open}
        onClose={handleClose}
        PaperProps={{
          elevation: 0,
          sx: {
            overflow: "visible",
            filter: "drop-shadow(0px 2px 8px rgba(0,0,0,0.32))",
            mt: 1.5,
            border: "1px solid",
            borderColor: "divider",
            width: "250px",
          },
        }}
        transformOrigin={{ horizontal: "right", vertical: "top" }}
        anchorOrigin={{ horizontal: "right", vertical: "bottom" }}>
        <Stack mb={1.3} ml={2} spacing={-0.7}>
          <Typography variant='subtitle1' fontSize={20}>
            {item[0]}
          </Typography>
          <Typography variant='subtitle2' fontSize={15} color={"text.secondary"}>
            {item[1] + ", " + item[2]}
          </Typography>
        </Stack>
        <Divider sx={{ marginBottom: "8px" }} />
        <Stack spacing={1} sx={{ maxHeight: "350px", overflow: "auto" }}>
          <MenuItem>
            <ListItemIcon>
              <TransferWithinAStationIcon />
            </ListItemIcon>
            <ListItemText
              primary={
                <Typography mr={1.3} whiteSpace='normal' variant='body1' color='text.primary'>
                  Przekaż przedmiot
                </Typography>
              }
            />
          </MenuItem>
          <MenuItem
            onClick={() => {
              cefData("deleteItem", item)
            }}>
            <ListItemIcon>
              <LocationSearchingIcon />
            </ListItemIcon>
            <ListItemText
              primary={
                <Typography mr={1.3} whiteSpace='normal' variant='body1' color='text.primary'>
                  Wyrzuć przedmiot
                </Typography>
              }
            />
          </MenuItem>
          <MenuItem
            onClick={() => {
              cefData("deleteItem", item)
            }}>
            <ListItemIcon>
              <DeleteIcon color='error' />
            </ListItemIcon>
            <ListItemText
              primary={
                <Typography mr={1.3} whiteSpace='normal' variant='body1' color='text.primary'>
                  Usuń przedmiot
                </Typography>
              }
            />
          </MenuItem>
        </Stack>
      </Menu>
    </>
  )
}
