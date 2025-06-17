class Nave {

  var velocidad   

  var direccion 

  var combustible 

  method cargarCombustible (cantidad) {
    combustible = combustible + cantidad
  }

  method descargarCombustible (unaCantidad) {
    combustible = (combustible - unaCantidad).max(0)
  }

  method initialize() {
    if (!velocidad.between(0, 100000) ||!direccion.between(-10,10) || combustible < 0) 
      self.error("No se puede instanciar")
  }

  method velocidad () = velocidad

  method direccion () = direccion

  method acelerar(cantidad) {

    velocidad = (velocidad + cantidad).min(100000)

  }

  method desacelerar(cantidad) {

    velocidad = (velocidad - cantidad).max(0)

  }

  method irHaciaElSol () {
    direccion = 10
  }

  method escaparDelSol () {
    direccion = -10
  }

  method ponerseParaleloAlSol () {
    direccion = 0
  }

  method acercarseUnPocoAlSol () {
    direccion = (direccion + 1).min(10)
  }

  method alejarseUnPocoDelSol () {
    direccion = (direccion - 1).max(-10)
  }

  method prepararViaje () {
    self.cargarCombustible(30000)
    self.acelerar(5000)
    self.accionAdicional()
  }
  
  method accionAdicional () 

  method tranquila () = combustible >= 4000 || velocidad <= 12000

  method escapar ()   

  method avisar () 
  
  method recibirAmenaza() {
    self.escapar()
    self.avisar()
  }

  method estaEnRelajo () = self.tranquila() && self.tienePocaActividad ()

  method tienePocaActividad () = true

}

class NaveBaliza inherits Nave {

var colorBaliza

var cambios = 0

method cambiarColorBaliza (unColor) {
  colorBaliza = unColor
  cambios = cambios + 1
}

override method accionAdicional() {

  self.cambiarColorBaliza("verde")
  self.ponerseParaleloAlSol()
  
}

override method tranquila () = super () and colorBaliza != "rojo" 

override method escapar() {
  self.irHaciaElSol()
  self.cambiarColorBaliza("rojo")
}

override method tienePocaActividad () = (cambios == 0)

}

class NavePasajeros inherits Nave {
  const property cantidadPasajeros
  var racionesComida = 0
  var racionesBebida = 0
  var racionesServidas = 0

  method racionesComida () = racionesComida

  method racionesBebida () = racionesBebida
  
  method cargarRacionBebida (unaRacion) {
    racionesBebida = racionesBebida + unaRacion
  }

  method descargarRacionBebida (unaRacion) {
    racionesBebida = (racionesBebida - unaRacion).min(0)
  }


  method cargarRacionComida (unaRacion) {
    racionesComida = racionesComida + unaRacion
  }

  method descargarRacionComida (unaRacion) {
    racionesComida = (racionesComida - unaRacion).min(0)
    racionesServidas = unaRacion + racionesServidas
  }

  override method accionAdicional() {
    
    self.cargarRacionBebida (6 * cantidadPasajeros)
    self.cargarRacionComida (4* cantidadPasajeros)
    self.acercarseUnPocoAlSol()
    
  }
  
  override method escapar () {
    velocidad = velocidad * 2
  }

  override method avisar () {

    self.descargarRacionComida (cantidadPasajeros)
    self.descargarRacionBebida(cantidadPasajeros)

  }

  override method tienePocaActividad () = racionesServidas >= 50

  
}

class NaveHospital inherits NavePasajeros {

  var quirofanoPreparado = true

  method prepararQuirofano () {
    quirofanoPreparado = true
  }

  method desPrepararQuirofano () {
    quirofanoPreparado = false
  }

  method quirofanoPreparado () = quirofanoPreparado

  override method tranquila () = super () and ! self.quirofanoPreparado()

  override method recibirAmenaza () {
    super ()
    self.prepararQuirofano()
  }

}

class NaveCombate inherits Nave {

const listaMensajes = []

var estaInvisible = true

var misilesDesplegados = true

method ponerseVisible() {
  estaInvisible = false
}
method ponerseInvisible() {
  estaInvisible = true
}
method estaInvisible() = estaInvisible

method desplegarMisiles() {
  misilesDesplegados = true
}
method replegarMisiles() {
  misilesDesplegados = false
}
method misilesDesplegados() = misilesDesplegados

method emitirMensaje(mensaje) {

  listaMensajes.add(mensaje) // string

}

method mensajesEmitidos() = listaMensajes

method primerMensajeEmitido() {
  if(listaMensajes.isEmpty()) self.error("no se emitió ningun mensaje")
  return listaMensajes.first()
}
method ultimoMensajeEmitido() {
  if(listaMensajes.isEmpty()) self.error("no se emitió ningun mensaje")
  return listaMensajes.last()
} 

method esEscueta() = listaMensajes.all({unMensaje => unMensaje.length() <=30})

method emitioMensaje(mensaje) = listaMensajes.contains(mensaje)

override method accionAdicional() {

  self.ponerseVisible()
  self.replegarMisiles()
  self.acelerar(15000)
  self.emitirMensaje("Saliendo en misión")
}

override method tranquila () = super () and ! self.misilesDesplegados ()

override method escapar () {
  self.acercarseUnPocoAlSol()
  self.acercarseUnPocoAlSol()
}

override method avisar () {
  self.emitirMensaje("Amenaza recibida")
}

}

class NaveCombateSigilosa inherits NaveCombate {

  override method tranquila () = super () and ! self.estaInvisible ()

  override method recibirAmenaza () {
    super ()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}

