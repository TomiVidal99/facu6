/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2026 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include "stdio.h"
#include "string.h"
/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

#define MESSAGE_BUFFER_SIZE (50)

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
TIM_HandleTypeDef htim2;

UART_HandleTypeDef huart1;

/* USER CODE BEGIN PV */

typedef struct {
	GPIO_PinState LED_A;
	GPIO_PinState LED_B;
	GPIO_PinState LED_C;
	GPIO_PinState BTN_A;
	GPIO_PinState BTN_B;
	GPIO_PinState BTN_C;
} State_t;

typedef enum {
	ALARMA_APAGADA,
	E1,
	E2,
	ALARMA_ENCENDIDA,
	E3,
	E4,
	DISPARO_ALARMA
} FSM_State;

typedef enum {
	BOTON_PRESIONADO,
	TICK
} FSM_senial;


/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_TIM2_Init(void);
static void MX_USART1_UART_Init(void);
/* USER CODE BEGIN PFP */
FSM_State FSM_ejecutar(FSM_State estado, FSM_senial senial);
/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

char msg_buffer[MESSAGE_BUFFER_SIZE] = {0};

volatile State_t state = {
		.LED_A = GPIO_PIN_RESET,
		.LED_B = GPIO_PIN_RESET,
		.LED_C = GPIO_PIN_RESET,
		.BTN_A = GPIO_PIN_SET,
		.BTN_B = GPIO_PIN_SET,
		.BTN_C = GPIO_PIN_SET,
};

volatile FSM_State estado_FSM = ALARMA_APAGADA;

volatile uint8_t contador_alarma = 0;

/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{

  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_TIM2_Init();
  MX_USART1_UART_Init();
  /* USER CODE BEGIN 2 */

  // Se inicia el timer para que genere una interrupción
  HAL_TIM_PWM_Start_IT(&htim2, TIM_CHANNEL_1);

  sniprintf(msg_buffer, MESSAGE_BUFFER_SIZE, "TEST\n\r");
  HAL_UART_Transmit(&huart1, (const uint8_t*) msg_buffer, MESSAGE_BUFFER_SIZE, HAL_MAX_DELAY);

  uint32_t counter = HAL_GetTick();
  uint32_t counter_alarma = HAL_GetTick();
  uint32_t counter_LEDS = HAL_GetTick();


  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */

	  if (HAL_GetTick() - counter_alarma > 1000) {
		  counter_alarma = HAL_GetTick();
		  estado_FSM = FSM_ejecutar(estado_FSM, TICK);
	  }


	  // Se actualizan los LEDs en el background
	  if (HAL_GetTick() - counter > 100) {
		  counter = HAL_GetTick();
		  HAL_GPIO_WritePin(LED_A_GPIO_Port, LED_A_Pin, state.LED_A);
		  HAL_GPIO_WritePin(LED_B_GPIO_Port, LED_B_Pin, state.LED_B);
		  HAL_GPIO_WritePin(LED_C_GPIO_Port, LED_C_Pin, state.LED_C);
	  }

	  if (HAL_GetTick() - counter_LEDS > 1000) {
		  counter_LEDS = HAL_GetTick();
		  state.LED_A = GPIO_PIN_RESET;
		  state.LED_B = GPIO_PIN_RESET;
		  state.LED_C = GPIO_PIN_RESET;
	  }


	  // CODIGO de DEBUG
//	  if (HAL_GPIO_ReadPin(BTN_A_GPIO_Port, BTN_A_Pin) == GPIO_PIN_RESET) {
//		  HAL_GPIO_WritePin(LED_A_GPIO_Port, LED_A_Pin, GPIO_PIN_SET);
//	  } else {
//		  HAL_GPIO_WritePin(LED_A_GPIO_Port, LED_A_Pin, GPIO_PIN_RESET);
//	  }
//
//	  if (HAL_GPIO_ReadPin(BTN_B_GPIO_Port, BTN_B_Pin) == GPIO_PIN_RESET) {
//		  HAL_GPIO_WritePin(LED_B_GPIO_Port, LED_B_Pin, GPIO_PIN_SET);
//	  } else {
//		  HAL_GPIO_WritePin(LED_B_GPIO_Port, LED_B_Pin, GPIO_PIN_RESET);
//	  }
//
//	  if (HAL_GPIO_ReadPin(BTN_C_GPIO_Port, BTN_C_Pin) == GPIO_PIN_RESET) {
//		  HAL_GPIO_WritePin(LED_C_GPIO_Port, LED_C_Pin, GPIO_PIN_SET);
//	  } else {
//		  HAL_GPIO_WritePin(LED_C_GPIO_Port, LED_C_Pin, GPIO_PIN_RESET);
//	  }


  }
  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_ON;
  RCC_OscInitStruct.HSEPredivValue = RCC_HSE_PREDIV_DIV1;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLMUL = RCC_PLL_MUL9;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_2) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * @brief TIM2 Initialization Function
  * @param None
  * @retval None
  */
static void MX_TIM2_Init(void)
{

  /* USER CODE BEGIN TIM2_Init 0 */

  /* USER CODE END TIM2_Init 0 */

  TIM_ClockConfigTypeDef sClockSourceConfig = {0};
  TIM_MasterConfigTypeDef sMasterConfig = {0};
  TIM_OC_InitTypeDef sConfigOC = {0};

  /* USER CODE BEGIN TIM2_Init 1 */

  /* USER CODE END TIM2_Init 1 */
  htim2.Instance = TIM2;
  htim2.Init.Prescaler = 36000-1;
  htim2.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim2.Init.Period = 6000;
  htim2.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  htim2.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_DISABLE;
  if (HAL_TIM_Base_Init(&htim2) != HAL_OK)
  {
    Error_Handler();
  }
  sClockSourceConfig.ClockSource = TIM_CLOCKSOURCE_INTERNAL;
  if (HAL_TIM_ConfigClockSource(&htim2, &sClockSourceConfig) != HAL_OK)
  {
    Error_Handler();
  }
  if (HAL_TIM_PWM_Init(&htim2) != HAL_OK)
  {
    Error_Handler();
  }
  sMasterConfig.MasterOutputTrigger = TIM_TRGO_RESET;
  sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
  if (HAL_TIMEx_MasterConfigSynchronization(&htim2, &sMasterConfig) != HAL_OK)
  {
    Error_Handler();
  }
  sConfigOC.OCMode = TIM_OCMODE_PWM1;
  sConfigOC.Pulse = 3000;
  sConfigOC.OCPolarity = TIM_OCPOLARITY_HIGH;
  sConfigOC.OCFastMode = TIM_OCFAST_DISABLE;
  if (HAL_TIM_PWM_ConfigChannel(&htim2, &sConfigOC, TIM_CHANNEL_1) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN TIM2_Init 2 */

  /* USER CODE END TIM2_Init 2 */

}

/**
  * @brief USART1 Initialization Function
  * @param None
  * @retval None
  */
static void MX_USART1_UART_Init(void)
{

  /* USER CODE BEGIN USART1_Init 0 */

  /* USER CODE END USART1_Init 0 */

  /* USER CODE BEGIN USART1_Init 1 */

  /* USER CODE END USART1_Init 1 */
  huart1.Instance = USART1;
  huart1.Init.BaudRate = 115200;
  huart1.Init.WordLength = UART_WORDLENGTH_8B;
  huart1.Init.StopBits = UART_STOPBITS_1;
  huart1.Init.Parity = UART_PARITY_NONE;
  huart1.Init.Mode = UART_MODE_TX_RX;
  huart1.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart1.Init.OverSampling = UART_OVERSAMPLING_16;
  if (HAL_UART_Init(&huart1) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN USART1_Init 2 */

  /* USER CODE END USART1_Init 2 */

}

/**
  * @brief GPIO Initialization Function
  * @param None
  * @retval None
  */
static void MX_GPIO_Init(void)
{
  GPIO_InitTypeDef GPIO_InitStruct = {0};
  /* USER CODE BEGIN MX_GPIO_Init_1 */

  /* USER CODE END MX_GPIO_Init_1 */

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOC_CLK_ENABLE();
  __HAL_RCC_GPIOD_CLK_ENABLE();
  __HAL_RCC_GPIOA_CLK_ENABLE();
  __HAL_RCC_GPIOB_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(DEBUG_LED_GPIO_Port, DEBUG_LED_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOA, LED_A_Pin|LED_B_Pin|LED_C_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin : DEBUG_LED_Pin */
  GPIO_InitStruct.Pin = DEBUG_LED_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(DEBUG_LED_GPIO_Port, &GPIO_InitStruct);

  /*Configure GPIO pins : LED_A_Pin LED_B_Pin LED_C_Pin */
  GPIO_InitStruct.Pin = LED_A_Pin|LED_B_Pin|LED_C_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

  /*Configure GPIO pins : BTN_C_Pin BTN_B_Pin BTN_A_Pin */
  GPIO_InitStruct.Pin = BTN_C_Pin|BTN_B_Pin|BTN_A_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_PULLUP;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

  /* USER CODE BEGIN MX_GPIO_Init_2 */

  /* USER CODE END MX_GPIO_Init_2 */
}

/* USER CODE BEGIN 4 */
void HAL_TIM_OC_DelayElapsedCallback(TIM_HandleTypeDef *htim) {
	uint8_t algun_boton_presionado = 0;
	HAL_GPIO_TogglePin(DEBUG_LED_GPIO_Port, DEBUG_LED_Pin);
	if (htim->Instance == TIM2) {

		// Se hace polling en el foreground

	// Se lee el botón A
	  if (HAL_GPIO_ReadPin(BTN_A_GPIO_Port, BTN_A_Pin) == GPIO_PIN_RESET) {
		  state.LED_A = GPIO_PIN_SET;
		  algun_boton_presionado=1;
	  } else  {
		  state.LED_A = GPIO_PIN_RESET;
	  }

	// Se lee el botón B
	  if (HAL_GPIO_ReadPin(BTN_B_GPIO_Port, BTN_B_Pin) == GPIO_PIN_RESET) {
		  state.LED_B = GPIO_PIN_SET;
		  algun_boton_presionado=1;
	  } else  {
		  state.LED_B = GPIO_PIN_RESET;
	  }

	// Se lee el botón C
	  if (HAL_GPIO_ReadPin(BTN_C_GPIO_Port, BTN_C_Pin) == GPIO_PIN_RESET) {
		  state.LED_C = GPIO_PIN_SET;
		  algun_boton_presionado=1;
	  } else  {
		  state.LED_C = GPIO_PIN_RESET;
	  }

	  if (algun_boton_presionado == 1) {
		  estado_FSM = FSM_ejecutar(estado_FSM, BOTON_PRESIONADO);
	  }

	}
}



FSM_State FSM_ejecutar(FSM_State estado, FSM_senial senial) {
	// Se verifica la secuencia
	switch (estado) {
	case ALARMA_APAGADA:
		if (senial == BOTON_PRESIONADO) {
			if (
					state.LED_A == GPIO_PIN_SET &&
					state.LED_B == GPIO_PIN_RESET &&
					state.LED_C == GPIO_PIN_RESET
			)  {
				return  E1;}
		}
		break;

	case E1:
		if (senial == BOTON_PRESIONADO) {
			if (
					state.LED_A == GPIO_PIN_SET &&
					state.LED_B == GPIO_PIN_SET &&
					state.LED_C == GPIO_PIN_RESET
			)  {
				return  E2; }
			else if (
					state.LED_A == GPIO_PIN_SET &&
					state.LED_B == GPIO_PIN_RESET &&
					state.LED_C == GPIO_PIN_RESET
			){
				return  E1; }
		}
		break;

	case E2:
		if (senial == BOTON_PRESIONADO) {
			if (
					state.LED_A == GPIO_PIN_RESET &&
					state.LED_B == GPIO_PIN_RESET &&
					state.LED_C == GPIO_PIN_SET
			)  {
				memset(msg_buffer, 0, MESSAGE_BUFFER_SIZE);
				sniprintf(msg_buffer, MESSAGE_BUFFER_SIZE, "ALARMA ACTIVADA\n\r");
				HAL_UART_Transmit(&huart1, (const uint8_t*) msg_buffer, MESSAGE_BUFFER_SIZE, HAL_MAX_DELAY);
				return  ALARMA_ENCENDIDA;
			}
			else if (
					state.LED_A == GPIO_PIN_SET &&
					state.LED_B == GPIO_PIN_RESET &&
					state.LED_C == GPIO_PIN_RESET
			){
				return  E1; }
			else if (
					state.LED_A == GPIO_PIN_SET &&
					state.LED_B == GPIO_PIN_SET &&
					state.LED_C == GPIO_PIN_RESET
			){
				return  E2; }
		}
		break;


	case ALARMA_ENCENDIDA:
		if (senial == BOTON_PRESIONADO) {
			if (
					state.LED_A == GPIO_PIN_SET &&
					state.LED_B == GPIO_PIN_RESET &&
					state.LED_C == GPIO_PIN_RESET
			)  {
				return  E3;
			} else {
				return  DISPARO_ALARMA;
			}
		}
		break;

	case E3:
		if (senial == BOTON_PRESIONADO) {
			if (
					state.LED_A == GPIO_PIN_SET &&
					state.LED_B == GPIO_PIN_SET &&
					state.LED_C == GPIO_PIN_RESET
			)  {
				return  E4;
			} else {
				return  DISPARO_ALARMA;
			}
		}
		break;


	case E4:
		if (senial == BOTON_PRESIONADO) {
			if (
					state.LED_A == GPIO_PIN_RESET &&
					state.LED_B == GPIO_PIN_RESET &&
					state.LED_C == GPIO_PIN_SET
			)  {
				memset(msg_buffer, 0, MESSAGE_BUFFER_SIZE);
				sniprintf(msg_buffer, MESSAGE_BUFFER_SIZE, "ALARMA DESACTIVADA\n\r");
				HAL_UART_Transmit(&huart1, (const uint8_t*) msg_buffer, MESSAGE_BUFFER_SIZE, HAL_MAX_DELAY);
				return  ALARMA_APAGADA;
			} else {
				return  DISPARO_ALARMA;
			}
		}
		break;


	case DISPARO_ALARMA:
		if (senial == TICK) {
			memset(msg_buffer, 0, MESSAGE_BUFFER_SIZE);
			sniprintf(msg_buffer, MESSAGE_BUFFER_SIZE, "ALARMA!\n\r");
			HAL_UART_Transmit(&huart1, (const uint8_t*) msg_buffer, MESSAGE_BUFFER_SIZE, HAL_MAX_DELAY);
			if (contador_alarma >= 4) {
				contador_alarma = 0;
				return ALARMA_ENCENDIDA;
			}
			contador_alarma++;
		} else if (senial == BOTON_PRESIONADO) {
			return DISPARO_ALARMA;
		}
		break;
		default:
			return estado;
	}
	return estado;
}
/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  __disable_irq();
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}
#ifdef USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
