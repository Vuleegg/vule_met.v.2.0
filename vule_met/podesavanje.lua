Config = {}

Config.Blipovi = {
  blip1 = {
    ime = 'Hemijski Elementi',
    kordinatablipa = vector3(1173.183, -2939.41, 5.9021),
    idblipa = 436,
    velicina = 0.8,
    boja = 1,
  },
  blip2 = {
    ime = 'Kuvanje Met-a',
    kordinatablipa = vector3(3559.503, 3673.973, 29.367),
    idblipa = 140,
    velicina = 0.8,
    boja = 5,
  },
  blip3 = {
    ime = 'Prerada Met-a',
    kordinatablipa = vector3(1391.846, 3605.776, 38.941),
    idblipa = 267,
    velicina = 0.8,
    boja = 1,
  },
  blip4 = {
    ime = 'Prodaja Met-a',
    kordinatablipa = vector3(2164.657, 4989.139, 41.361),
    idblipa = 267,
    velicina = 0.8,
    boja = 1,
  },
}

Config.Kuvanje = {
  kuvanje1 = {
    kuvanjekord = vector3(3559.503, 3673.973, 29.367),
    vidizonu = false,
     --poosao = 'zemunski', --pomerite crtice ako hocete da samo neki posao moze prodavati
  },
}

Config.Prerada = {
  prerada1 = {
    preradakord = vector3(1391.379, 3605.587, 39.061),
    prikazizonu = false,
     --poosao = 'zemunski', --pomerite crtice ako hocete da samo neki posao moze prodavati
  },
}

Config.Prodaja = {
  prodajadroge = {
    kordinateped = vector3(2164.657, 4989.139, 40.361),
    headingped = 120.0,
    pokazizonu = false, --ako hocete da handlujete zonu i velicinu oko ped-a
    --poosao = 'zemunski', --pomerite crtice ako hocete da samo neki posao moze prodavati
  },
}

Config.Prevod = { --notifikacije
    ["ulaznaporuka"] = {
        message = 'Met sistem uspesno ucitan!',
        type = "sucess",
        time = 5000
    },
    ["iskoristiliste"] = {
      message = 'Iskoristili ste met!',
      type = "sucess",
      time = 5000
    },
}

Config.Pretraga = {
    methsearch = {coords = vector3(1173.183, -2939.41, 5.9021)}, --propovi 
    
}

Config.Burici = {
  {
    zone = {name = 'burad', x = 1173.183, y = -2939.41, z = 5.9021, l = 50.0, w = 50.0, h = 0, minZ = 2.902, maxZ = 9.902}, --zona
  },
}