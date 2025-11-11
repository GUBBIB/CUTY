import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App'
import Pdf from './component/PdfRelation/Pdf'
import { BrowserRouter, Route, Routes } from 'react-router-dom'
import Privacy from './component/Privacy/Privacy'


createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<App />} />
        <Route path="/student-pdf" element={<Pdf />} />

        <Route path="/privacy-policy" element={<Privacy />} />
      </Routes>
    </BrowserRouter>
  </StrictMode>,
)
