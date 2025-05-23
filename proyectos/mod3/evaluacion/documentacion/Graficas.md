
# MATERIALES NECESARIOS PARA EL TRABAJO DE VISUALIZACIÓN


## PALETAS DE COLORES DE LA LIBRERÍA SEABORN

📌 1. Paletas categóricas

Estas son ideales para datos cualitativos.

palette="deep"       # 🎨 Colores vibrantes (por defecto)

palette="muted"      # 🌅 Tonos suaves

palette="bright"     # 🌈 Colores vivos

palette="pastel"     # 🎨 Tonos claros

palette="dark"       # 🌑 Tonos oscuros

palette="colorblind" # 👁‍🗨 Para mejor accesibilidad

📌 2. Paletas secuenciales

Usadas para valores continuos (de menor a mayor).

palette="Blues"   # 🔵 Azul de claro a oscuro

palette="Oranges" # 🟠 Naranja de claro a oscuro

palette="Purples" # 🟣 Morado de claro a oscuro

palette="Greens"  # 🟢 Verde de claro a oscuro

Se pueden invertir agregando _r al final:

palette="Blues_r"  # 🔄 Azul oscuro a claro

📌 3. Paletas divergentes

Para datos con valores negativos y positivos.

palette="coolwarm" # 🔵➡🔴 Transición de frío a caliente

palette="RdBu"     # 🔴🔵 Rojo a Azul

palette="PiYG"     # 💖💚 Rosa a Verde


## CÓDIGOS PARA LA MEJORA DE LAS VISUALIZACIONES:


#### plt.grid: agrega o personaliza la cuadrícula en un gráfico.

axis='y' → Aplica la cuadrícula solo en el eje Y.

linestyle='--' → Usa líneas discontinuas para la cuadrícula.

alpha=0.7 → Ajusta la transparencia de la cuadrícula.


#### plt.xticks(rotation=45) 

Se usa en Matplotlib para rotar las etiquetas del eje X 45 grados.


#### plt.tight_layout()

Es un comando en Matplotlib que ajusta automáticamente los márgenes y el espaciado entre los elementos de una gráfica (como los ejes, los títulos, las leyendas y las etiquetas) para evitar que se superpongan y se vean más claros y ordenados.

