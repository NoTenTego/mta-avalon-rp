import React from "react"
import { Card } from "@mui/material"

function CenteredCard({ children, style }) {
  return <Card sx={{ position: "absolute", left: "50%", top: "50%", transform: "translate(-50%, -50%)", padding: "1rem", ...style }}>{children}</Card>
}

export default CenteredCard
