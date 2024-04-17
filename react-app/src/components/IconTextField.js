import { InputAdornment, IconButton } from "@mui/material"
import TextField from "@mui/material/TextField"

export const IconTextField = ({ iconStart, iconEnd, clickFunction, ...props }) => {
  return (
    <TextField
      {...props}
      InputProps={{
        startAdornment: iconStart ? <InputAdornment position='start'>{iconStart}</InputAdornment> : null,
        endAdornment: iconEnd ? (
          <InputAdornment position='end'>
            <IconButton onClick={clickFunction}>{iconEnd}</IconButton>
          </InputAdornment>
        ) : null,
      }}
    />
  )
}
