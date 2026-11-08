import os
import matplotlib.pyplot as plt
import numpy as np

# Crear directorio para las figuras si no existe
output_dir = r"C:\Bacilio\app_movil_conversacional_programa_especializacion\tesis\figuras"
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# Configuración de estilo global para APA 7 (limpio, sin grid excesivo, fuentes claras)
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['font.sans-serif'] = ['Arial', 'Liberation Sans', 'DejaVu Sans']
plt.rcParams['axes.unicode_minus'] = False

# Paleta de colores profesional y sobria (Azul clásico para Pre-test, Azul acero/celeste para Post-test)
color_pre = '#7F8C8D'   # Gris neutro profesional
color_post = '#2980B9'  # Azul corporativo/académico

def save_chart(title_name, labels, pre_data, post_data, filename, ylabel="Porcentaje (%)"):
    x = np.arange(len(labels))
    width = 0.35

    fig, ax = plt.subplots(figsize=(7, 5), dpi=300)
    
    # Dibujar barras
    rects1 = ax.bar(x - width/2, pre_data, width, label='Pre-test', color=color_pre, edgecolor='black', linewidth=0.7)
    rects2 = ax.bar(x + width/2, post_data, width, label='Post-test', color=color_post, edgecolor='black', linewidth=0.7)

    # Configuración de ejes al estilo APA (líneas invisibles arriba y derecha)
    ax.set_ylabel(ylabel, fontsize=11, fontweight='bold', labelpad=10)
    ax.set_title(title_name, fontsize=12, fontweight='bold', pad=15)
    ax.set_xticks(x)
    ax.set_xticklabels(labels, fontsize=10)
    ax.legend(frameon=True, facecolor='white', edgecolor='none', loc='upper left')
    
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['left'].set_color('#333333')
    ax.spines['bottom'].set_color('#333333')
    
    # Establecer límite superior para dar espacio a etiquetas de datos
    ax.set_ylim(0, 105)

    # Añadir valores sobre las barras
    def autolabel(rects):
        for rect in rects:
            height = rect.get_height()
            ax.annotate(f'{height:.2f}%',
                        xy=(rect.get_x() + rect.get_width() / 2, height),
                        xytext=(0, 3),  # Desplazamiento vertical de 3 puntos
                        textcoords="offset points",
                        ha='center', va='bottom', fontsize=9, fontweight='semibold')

    autolabel(rects1)
    autolabel(rects2)

    fig.tight_layout()
    
    path = os.path.join(output_dir, filename)
    plt.savefig(path, bbox_inches='tight')
    plt.close()
    print(f"Gráfico guardado en: {path}")

# --- 1. SATISFACCIÓN ---
labels_sat = ['Bajo', 'Medio', 'Muy Alto']
pre_sat = [57.88, 30.14, 11.99]
post_sat = [3.42, 11.64, 84.93]
save_chart(
    "Niveles de Satisfacción del Usuario\n(Pre-test vs. Post-test)",
    labels_sat, pre_sat, post_sat,
    "figura1_satisfaccion.png"
)

# --- 2. UTILIDAD PERCIBIDA ---
labels_ut = ['Baja Utilidad', 'Moderada Utilidad', 'Alta Utilidad']
pre_ut = [52.05, 31.51, 16.44]
post_ut = [2.74, 9.93, 87.33]
save_chart(
    "Niveles de Utilidad Percibida\n(Pre-test vs. Post-test)",
    labels_ut, pre_ut, post_ut,
    "figura2_utilidad.png"
)

# --- 3. CLARIDAD EN LA DECISIÓN ---
labels_cla = ['Baja Claridad', 'Moderada Claridad', 'Alta Claridad']
pre_cla = [64.04, 27.05, 8.90]
post_cla = [4.11, 14.04, 81.85]
save_chart(
    "Niveles de Claridad en la Decisión\n(Pre-test vs. Post-test)",
    labels_cla, pre_cla, post_cla,
    "figura3_claridad.png"
)

# --- 4. FUNDAMENTACIÓN DE LA ELECCIÓN ---
labels_fund = ['Débilmente', 'Medianamente', 'Sólidamente']
pre_fund = [64.38, 29.11, 6.51]
post_fund = [4.11, 13.01, 82.88]
save_chart(
    "Niveles de Fundamentación de la Elección\n(Pre-test vs. Post-test)",
    labels_fund, pre_fund, post_fund,
    "figura4_fundamentacion.png"
)

print("Proceso de generación de gráficos finalizado con éxito.")
