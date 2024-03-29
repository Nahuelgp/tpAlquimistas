object alquimista {
  var itemsDeCombate = []
  var itemsDeRecoleccion = []
  
  method tieneCriterio() {
    return self.cantidadDeItemsDeCombateEfectivos() >= self.cantidadDeItemsDeCombate() / 2
  }
  
  method cantidadDeItemsDeCombate() {
    return itemsDeCombate.size()
  }
  
  method agregarItem(unItem){
  	itemsDeCombate.add(unItem)
  }
  
  method agregarItemDeRecoleccion(unItem){
  	itemsDeRecoleccion.add(unItem)
  }
  
  method cantidadDeItemsDeCombateEfectivos() {
    return itemsDeCombate.count({ itemDeCombate =>
      itemDeCombate.esEfectivo()
    })
  }
  method esBuenExplorador() {
  	return self.cantidadDeItemsDeRecoleccion() >= 3
  }
		
  method cantidadDeItemsDeRecoleccion() {
  	return itemsDeRecoleccion.size()
  }
  
  method capacidadOfensiva(){
  	return itemsDeCombate.sum({item => item.capacidadOfensiva()})
  }
  
  method esProfesional(){
  	return ((self.calidadPromedioDeItems() > 50) and (self.esBuenExplorador()) and (self.cantidadDeItemsDeCombate() == self.cantidadDeItemsDeCombateEfectivos()))
  }
  
  method calidadPromedioDeItems(){
  	return (self.calidadDeItemsDeRecoleccion() + self.calidadDeItemsDeCombate())/(self.cantidadDeItemsDeRecoleccion() + self.cantidadDeItemsDeCombate())
  }
  
  method calidadDeItemsDeRecoleccion(){
  	return 30 + itemsDeRecoleccion.sum({materiales =>  materiales.calidad() / 10})
  }
  
  method calidadDeItemsDeCombate(){
  	return itemsDeRecoleccion.sum({materiales =>  materiales.calidad()})
  }
  
}

object bomba {
  var danio = 150
  var materiales = []
  
  method esEfectivo() {
    return danio > 100
  }
  
  method capacidadOfensiva(){
  	return danio/2
  }
  
  method calidad(){
  	return materiales.min({material => material.calidadDeMaterial()})
  }
  
}

object pocion {
  var materiales = []
  var poderCurativo = 25
  
  method capacidadOfensiva(){
  	return poderCurativo + 10*self.cantidadDeMaterialesMisticos()
  }
  
  method cantidadDeMaterialesMisticos(){
  	return materiales.count({item => item.fueCreadaConAlgunMaterialMistico()})
  }
  
  method esEfectivo() {
    return poderCurativo > 50 and self.fueCreadaConAlgunMaterialMistico()
  }
  
  method fueCreadaConAlgunMaterialMistico() {
    return materiales.any({ material =>
      material.esMistico()
    })
  }
  
  method primerMaterialMistico() {
  	return materiales.find({material => material.esMistico()})
  }
  
  method calidad() {
  	if(self.fueCreadaConAlgunMaterialMistico()) {
  		return self.primerMaterialMistico().calidadDeMaterial()
  	}
  	return materiales.head().calidadDeMaterial()
  }
  
}

object debilitador {
  var materiales = []
  var potencia = 0
  
  method esEfectivo() {
    return potencia > 0 and self.fueCreadoPorAlgunMaterialMistico().negate()
  }
  
  method fueCreadoPorAlgunMaterialMistico() {
    return materiales.any({ material =>
      material.esMistico()
    })
  }
  
  method cantidadDeMaterialesMisticos(){
  	return materiales.count({item => item.fueCreadaConAlgunMaterialMistico()})
  }
  
  method capacidadOfensiva(){
  	if(self.fueCreadoPorAlgunMaterialMistico()){
  		return 12*self.cantidadDeMaterialesMisticos()
  	}
  	else {
  		return 5
  	}
  }
  
  method calidad(){
      return self.dosMaterialesDeMayorCalidad().sum() / 2
  }

  method dosMaterialesDeMayorCalidad(){
  return materiales.sortBy({unMaterial,otroMaterial => unMaterial.calidadDeMaterial() > otroMaterial.calidadDeMaterial()}).take(2)
  }

}

