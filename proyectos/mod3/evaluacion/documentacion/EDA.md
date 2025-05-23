# 📚 Conocimiento de los Archivos

## 1. Archivo: **Customer Loyalty History** (`df_clientes`)

Este archivo contiene información de los clientes que han hecho uso de la aerolínea.

### Columnas de registro:
- **Loyalty Number**: Identificador único del cliente.
- **Country**: País de residencia.
- **Province**: Provincia de residencia.
- **City**: Ciudad de residencia.
- **Postal Code**: Código postal.
- **Gender**: Género del cliente.
- **Education**: Nivel educativo alcanzado.
- **Salary**: Salario.
- **Marital Status**: Estado civil.
- **Loyalty Card**: Tipo de tarjeta de lealtad.
- **CLV**: Valor total estimado que el cliente aporta a la empresa.
- **Enrollment Type**: Tipo de inscripción en el programa de lealtad.
- **Enrollment Year**: Año en que el cliente se inscribió.
- **Enrollment Month**: Mes en que el cliente se inscribió.
- **Cancellation Year**: Año en que el cliente canceló su suscripción.
- **Cancellation Month**: Mes en que el cliente canceló su suscripción.

### Transformaciones y Limpieza:

- Se modifica el nombre de las columnas, generando guiones bajos (`_`) en los espacios entre palabras.

- Tamaño del registro: **16,737 filas** y **16 columnas** originales.

### Revisión General:

| Columna              | Non-Null Count | Dtype    | Descripción |
|----------------------|----------------|----------|-------------|
| **Loyalty Number**    | 16,737         | int64    | Identificador único del cliente (sin valores nulos, tipo correcto). |
| **Country**           | 16,737         | object   | País de residencia (sin valores nulos, tipo correcto). |
| **Province**          | 16,737         | object   | Provincia de residencia (sin valores nulos, tipo correcto). |
| **City**              | 16,737         | object   | Ciudad de residencia (sin valores nulos, tipo correcto). |
| **Postal Code**       | 16,737         | object   | Código postal (sin valores nulos, tipo correcto). |
| **Gender**            | 16,737         | object   | Género del cliente (sin valores nulos, tipo correcto). |
| **Education**         | 16,737         | object   | Nivel educativo alcanzado (sin valores nulos, tipo correcto). |
| **Salary**            | 12,499         | float64  | Salario (con valores nulos, tipo incorrecto - debería ser int). |
| **Marital Status**    | 16,737         | object   | Estado civil (sin valores nulos, tipo correcto). |
| **Loyalty Card**      | 16,737         | object   | Tipo de tarjeta de lealtad (sin valores nulos, tipo correcto). |
| **CLV**               | 16,737         | float64  | Valor total estimado (sin valores nulos, tipo correcto). |
| **Enrollment Type**   | 16,737         | object   | Tipo de inscripción (con valores nulos, tipo correcto). |
| **Enrollment Year**   | 16,737         | int64    | Año de inscripción (con valores nulos, se unificará con el mes). |
| **Enrollment Month**  | 16,737         | int64    | Mes de inscripción (con valores nulos, se unificará con el año). |
| **Cancellation Year** | 2,067          | float64  | Año de cancelación (con muchos nulos, tipo incorrecto). |
| **Cancellation Month**| 2,067          | float64  | Mes de cancelación (con muchos nulos, tipo incorrecto). |

### Resumen de transformaciones necesarias en cuanto al tipo de dato de las columnas:

- **Salary**: Se cambiará a `int64` ya que todos los valores son enteros.

- **Cancellation Year**: Se cambiará a `int64` para corregir el tipo de dato.

- **Cancellation Month**: Se cambiará a `int64` para corregir el tipo de dato.

### Acciones:

- **Eliminación de duplicados**: No hay duplicados.

- **Porcentaje de valores nulos**:

    - **Salary**: 25.32%

    - **Cancellation Year**: 87.65%

    - **Cancellation Month**: 87.65%

### Decisión y valoración:

- Se **eliminan** las columnas de **Cancellation Year** y **Cancellation Month** debido al alto porcentaje de valores nulos.

- Se crea un nuevo dataset **`df_clientes_bajas`** con los datos de los clientes que han cancelado su suscripción. Este dataset puede ser útil en análisis futuros sobre los clientes que cancelan su suscripción.

- **Imputación en la columna Salary**: Los valores nulos de **Salary** se imputan con el método KNN.

### 📊 Estadísticas Descriptivas

| Métrica          | Count   | Mean         | Std Dev       | Min      | 25%      | 50%       | 75%      | Max      |
|-----------------|--------|-------------|-------------|---------|---------|---------|---------|---------|
| **Loyalty Number** | 16,737  | 549,735.88  | 258,912.13  | 100,018 | 326,603 | 550,434 | 772,019 | 999,986 |
| **Salary**        | 16,737  | 79,359.34   | 30,029.31   | 9,081   | 63,899  | 79,359.34 | 82,940  | 407,228 |
| **CLV**          | 16,737  | 7,988.90    | 6,860.98    | 1,898.01 | 3,980.84 | 5,780.18 | 8,940.58 | 83,325.38 |


### Revisión de datos únicos en las columnas categóricas:

- **Country**: `'Canada'` (único valor).
- **Province**: `'Ontario', 'Alberta', ...` (diversas provincias).
- **City**: Diversas ciudades de Canadá.
- **Postal Code**: Diversos códigos postales canadienses.
- **Gender**: `'Female', 'Male'` (género).
- **Education**: `'Bachelor', 'College', 'Master', ...`.
- **Marital Status**: `'Married', 'Divorced', 'Single'`.
- **Loyalty Card**: `'Star', 'Aurora', 'Nova'`.

Se genera un guion bajo (`_`) en los espacios entre palabras y se elimina cualquier espacio innecesario al principio o al final de los datos.

### Modificación final:

- Se elimina la columna **Country** porque todos los clientes son de Canadá.

- Se añade el símbolo **`$`** a la columna de **Salary** para indicar la moneda de Canadá.

---

## 2. Archivo: **Customer Flight Analysis** (`df_vuelos`)

Este archivo contiene información sobre los vuelos reservados por los clientes.

### Revisión general:

- **Número de registros**: 405,624
- **Columnas**:
    - **Loyalty Number**: Identificador único del cliente.
    - **Year**: Año del vuelo.
    - **Month**: Mes del vuelo.
    - **Flights Booked**: Número de vuelos reservados.
    - **Flights with Companions**: Vuelos reservados con acompañantes.
    - **Total Flights**: Total de vuelos.
    - **Distance**: Distancia de los vuelos.
    - **Points Accumulated**: Puntos acumulados.
    - **Points Redeemed**: Puntos redimidos.
    - **Dollar Cost Points Redeemed**: Costo en dólares de los puntos redimidos.

### Revisión:

| Columna                        | Non-Null Count | Dtype   | Descripción |
|---------------------------------|----------------|---------|-------------|
| **Loyalty Number**              | 405,624        | int64   | Identificador único del cliente. |
| **Year**                        | 405,624        | int64   | Año del vuelo. |
| **Month**                       | 405,624        | int64   | Mes del vuelo. |
| **Flights Booked**              | 405,624        | int64   | Número de vuelos reservados. |
| **Flights with Companions**     | 405,624        | int64   | Vuelos con acompañantes. |
| **Total Flights**               | 405,624        | int64   | Total de vuelos. |
| **Distance**                    | 405,624        | int64   | Distancia de los vuelos. |
| **Points Accumulated**          | 405,624        | float64 | Puntos acumulados. |
| **Points Redeemed**             | 405,624        | int64   | Puntos redimidos. |
| **Dollar Cost Points Redeemed** | 405,624        | int64   | Costo de los puntos redimidos en dólares. |

### Acciones:

- **Columna en común con `df_clientes`**: La columna **Loyalty Number** se utiliza para unir con el dataset de clientes.

- **Duplicados**: Se mantiene la duplicidad debido a la variabilidad de los datos de un mismo cliente a lo largo del tiempo (fechas diferentes).

- **Sin valores nulos**.

- **Tipos de datos correctos**, aunque se unifican las columnas de **Year** y **Month** en una sola columna de tipo fecha.
