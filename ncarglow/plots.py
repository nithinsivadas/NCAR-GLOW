from matplotlib.pyplot import figure
import xarray
import numpy as np

__all__ = ["precip", "ver"]


def precip(precip: xarray.DataArray):
    ax = figure().gca()
    ax.plot(precip["energy"] / 1e3, precip)
    ax.set_xlabel("Energy bin centers [keV]")
    ax.set_ylabel("hemispherical flux [cm$^{-2}$ s$^{-1}$ eV$^{-1}$]")
    ax.set_title("precipitation: differential number flux")
    ax.grid(True)


def temperature(iono: xarray.Dataset):
    time = iono.time
    location = iono.glatlon
    tail = f"\n{time} {location}"
    ax = figure().gca()
    ax.plot(iono["Ti"], iono["Ti"].alt_km, label="Ti")
    ax.plot(iono["Te"], iono["Te"].alt_km, label="Te")
    ax.plot(iono["Tn"], iono["Tn"].alt_km, label="Tn")
    ax.set_xlabel("Temperature [K]")
    ax.set_ylabel("altitude [km]")
    ax.set_title("Ion & Electron temperature" + tail)
    ax.grid(True)
    ax.legend()


def altitude(iono: xarray.Dataset):
    ax = figure().gca()
    ax.plot(iono.alt_km)
    ax.set_xlabel("altitude grid index #")
    ax.set_ylabel("altitude [km]")
    ax.set_title("altitude grid cells")
    ax.grid(True)


def ver(iono: xarray.Dataset):
    time = iono.time
    location = iono.glatlon
    tail = f"\n{time} {location}"
    ver_group(iono["ver"].loc[:, ["4278", "5577", "6300", "5200"]], "Visible emissions" + tail)
    ver_group(iono["ver"].loc[:, ["7320", "7774", "8446", "10400"]], "IR emissions" + tail)
    ver_group(iono["ver"].loc[:, ["3371", "3644", "3726", "1356", "1493", "1304", "LBH"]], "UV emissions" + tail)


def ver_group(iono: xarray.Dataset, ttxt: str):
    nm = np.nanmax(iono)
    if nm == 0 or np.isnan(nm):
        return

    colors = {"4278": "blue", "5577": "xkcd:dark lime green", "5200": "xkcd:golden yellow", "6300": "red"}

    ax = figure().gca()
    for w in iono.wavelength:
        ax.plot(iono.loc[:, w], iono.alt_km, label=w.item(), color=colors.get(w.item()))
    ax.set_xscale("log")
    ax.set_xlabel("Volume Emission Rate [Rayleigh]")
    ax.set_ylabel("altitude [km]")
    ax.set_title(ttxt)
    ax.grid(True)
    ax.legend()
