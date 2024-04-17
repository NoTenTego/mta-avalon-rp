import { TextField } from "@mui/material"

export const ReadTextField = ({ label, value }) => {
  return (
    <TextField
      id='outlined-read-only-input'
      label={label}
      defaultValue={value}
      InputProps={{
        readOnly: true,
      }}
      multiline
      variant='standard'
      focused={false}
      fullWidth
      sx={{
        "& .MuiInput-underline": {
          pointerEvents: "none",
        },
      }}
    />
  )
}
