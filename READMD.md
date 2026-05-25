# Surveillance in the Shadow of Redlining

##### An exploratory geospatial analysis of Chicago's police surveillance network and legacy of redlining.

## Setup and Run Instructions

Follow the steps below to render [Surveillance-in-the-Shadow.qmd](Surveillance-in-the-Shadow.qmd) into a self-contained HTML report.

### 1. Prerequisites

Install the following before you begin:

- **R** (>= 4.2 recommended) — https://cran.r-project.org/
- **Quarto** CLI (>= 1.4) — https://quarto.org/docs/get-started/
- **RStudio** (optional, but recommended) — opens the included `ChicagoSurveillanceMapping.Rproj` and provides a one-click Render button.
- A **Census API key**, free from the U.S. Census Bureau: https://api.census.gov/data/key_signup.html

### 2. Clone the repository

```bash
git clone https://github.com/brocksauvage/ChicagoSurveillanceAnalysis.git
cd ChicagoSurveillanceAnalysis
```

All paths inside the `.qmd` are relative to the project root, so commands must be run from this directory.

### 3. Create a project-local `.Renviron`

In the project root, create a file named `.Renviron` containing your Census API key:

```
CENSUS_API_KEY=your_key_here
```

The document loads this file at render time via `readRenviron(".Renviron")` and passes the key to `tidycensus::census_api_key()`. Do not commit `.Renviron` to version control.

### 4. Install R package dependencies

From an R console launched in the project root:

```r
install.packages(c(
  "sf", "dplyr", "leaflet", "tigris", "tidycensus",
  "spdep", "terra", "stars", "gstat"
))
```

`sf`, `terra`, and `stars` link against system libraries (GDAL, GEOS, PROJ). On macOS the easiest route is `brew install gdal geos proj`; on Debian/Ubuntu use `apt install libgdal-dev libgeos-dev libproj-dev`.

### 5. Confirm the data directory

The render pulls from local files under `data/`. Verify these are present (they ship with the repo):

- `data/pod_cameras.geojson`
- `data/redlights.csv`
- `data/speed_cameras.csv`
- `data/cameras.geojson.gz`
- `data/mappinginequality.json`

If any are missing, see the **Data Sources** section of the report for original download links.

### 6. Render the report

From the project root, run:

```bash
quarto render Surveillance-in-the-Shadow.qmd
```

Or open `ChicagoSurveillanceMapping.Rproj` in RStudio, open the `.qmd`, and click **Render**.

The first render will take a few minutes because `tigris` downloads and caches TIGER/Line boundary files. Output is written to `Surveillance-in-the-Shadow.html` alongside the source.