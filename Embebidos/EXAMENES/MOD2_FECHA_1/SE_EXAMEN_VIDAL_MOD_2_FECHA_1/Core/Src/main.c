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
#include "cmsis_os.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include <stdio.h>
#include "string.h"

/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
typedef StaticQueue_t osStaticMessageQDef_t;
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

typedef enum {
	ACTIVA,
	DESACTIVADA,
} EstadoAlarma;

typedef enum {
	ALARMA_ACTIVAR,
	ALARMA_DESACTIVAR,
	MOSTRAR_PROMEDIO
} MessageType;

typedef struct {
	MessageType message;
	uint32_t payload;
} QueueMessage_t;

volatile EstadoAlarma estadoAlarma = DESACTIVADA;

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
ADC_HandleTypeDef hadc1;

UART_HandleTypeDef huart1;

/* Definitions for MuestreoTask */
osThreadId_t MuestreoTaskHandle;
const osThreadAttr_t MuestreoTask_attributes = {
  .name = "MuestreoTask",
  .stack_size = 128 * 4,
  .priority = (osPriority_t) osPriorityRealtime,
};
/* Definitions for ProcesamientoTa */
osThreadId_t ProcesamientoTaHandle;
const osThreadAttr_t ProcesamientoTa_attributes = {
  .name = "ProcesamientoTa",
  .stack_size = 256 * 4,
  .priority = (osPriority_t) osPriorityAboveNormal,
};
/* Definitions for UITask */
osThreadId_t UITaskHandle;
const osThreadAttr_t UITask_attributes = {
  .name = "UITask",
  .stack_size = 128 * 4,
  .priority = (osPriority_t) osPriorityLow,
};
/* Definitions for Q1 */
osMessageQueueId_t Q1Handle;
uint8_t Q1Buffer[ 400 * sizeof( uint16_t ) ];
osStaticMessageQDef_t Q1ControlBlock;
const osMessageQueueAttr_t Q1_attributes = {
  .name = "Q1",
  .cb_mem = &Q1ControlBlock,
  .cb_size = sizeof(Q1ControlBlock),
  .mq_mem = &Q1Buffer,
  .mq_size = sizeof(Q1Buffer)
};
/* Definitions for Q2 */
osMessageQueueId_t Q2Handle;
uint8_t Q2Buffer[ 10 * sizeof( QueueMessage_t ) ];
osStaticMessageQDef_t Q2ControlBlock;
const osMessageQueueAttr_t Q2_attributes = {
  .name = "Q2",
  .cb_mem = &Q2ControlBlock,
  .cb_size = sizeof(Q2ControlBlock),
  .mq_mem = &Q2Buffer,
  .mq_size = sizeof(Q2Buffer)
};
/* USER CODE BEGIN PV */

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_ADC1_Init(void);
static void MX_USART1_UART_Init(void);
void StartDefaultTask(void *argument);
void processingData(void *argument);
void UI(void *argument);

/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

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
  MX_ADC1_Init();
  MX_USART1_UART_Init();
  /* USER CODE BEGIN 2 */

  HAL_GPIO_TogglePin(DEBUG_LED_GPIO_Port, DEBUG_LED_Pin);
  HAL_Delay(1000);
  HAL_GPIO_TogglePin(DEBUG_LED_GPIO_Port, DEBUG_LED_Pin);
  HAL_Delay(500);
  HAL_GPIO_TogglePin(DEBUG_LED_GPIO_Port, DEBUG_LED_Pin);
  HAL_Delay(1000);

  /* USER CODE END 2 */

  /* Init scheduler */
  osKernelInitialize();

  /* USER CODE BEGIN RTOS_MUTEX */
  /* add mutexes, ... */
  /* USER CODE END RTOS_MUTEX */

  /* USER CODE BEGIN RTOS_SEMAPHORES */
  /* add semaphores, ... */
  /* USER CODE END RTOS_SEMAPHORES */

  /* USER CODE BEGIN RTOS_TIMERS */
  /* start timers, add new ones, ... */
  /* USER CODE END RTOS_TIMERS */

  /* Create the queue(s) */
  /* creation of Q1 */
  Q1Handle = osMessageQueueNew (400, sizeof(uint16_t), &Q1_attributes);

  /* creation of Q2 */
  Q2Handle = osMessageQueueNew (10, sizeof(QueueMessage_t), &Q2_attributes);

  /* USER CODE BEGIN RTOS_QUEUES */
  /* add queues, ... */
  /* USER CODE END RTOS_QUEUES */

  /* Create the thread(s) */
  /* creation of MuestreoTask */
  MuestreoTaskHandle = osThreadNew(StartDefaultTask, NULL, &MuestreoTask_attributes);

  /* creation of ProcesamientoTa */
  ProcesamientoTaHandle = osThreadNew(processingData, NULL, &ProcesamientoTa_attributes);

  /* creation of UITask */
  UITaskHandle = osThreadNew(UI, NULL, &UITask_attributes);

  /* USER CODE BEGIN RTOS_THREADS */
  /* add threads, ... */
  /* USER CODE END RTOS_THREADS */

  /* USER CODE BEGIN RTOS_EVENTS */
  /* add events, ... */
  /* USER CODE END RTOS_EVENTS */

  /* Start scheduler */
  osKernelStart();

  /* We should never get here as control is now taken by the scheduler */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
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
  RCC_PeriphCLKInitTypeDef PeriphClkInit = {0};

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
  PeriphClkInit.PeriphClockSelection = RCC_PERIPHCLK_ADC;
  PeriphClkInit.AdcClockSelection = RCC_ADCPCLK2_DIV6;
  if (HAL_RCCEx_PeriphCLKConfig(&PeriphClkInit) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * @brief ADC1 Initialization Function
  * @param None
  * @retval None
  */
static void MX_ADC1_Init(void)
{

  /* USER CODE BEGIN ADC1_Init 0 */

  /* USER CODE END ADC1_Init 0 */

  ADC_ChannelConfTypeDef sConfig = {0};

  /* USER CODE BEGIN ADC1_Init 1 */

  /* USER CODE END ADC1_Init 1 */

  /** Common config
  */
  hadc1.Instance = ADC1;
  hadc1.Init.ScanConvMode = ADC_SCAN_DISABLE;
  hadc1.Init.ContinuousConvMode = DISABLE;
  hadc1.Init.DiscontinuousConvMode = DISABLE;
  hadc1.Init.ExternalTrigConv = ADC_SOFTWARE_START;
  hadc1.Init.DataAlign = ADC_DATAALIGN_RIGHT;
  hadc1.Init.NbrOfConversion = 1;
  if (HAL_ADC_Init(&hadc1) != HAL_OK)
  {
    Error_Handler();
  }

  /** Configure Regular Channel
  */
  sConfig.Channel = ADC_CHANNEL_0;
  sConfig.Rank = ADC_REGULAR_RANK_1;
  sConfig.SamplingTime = ADC_SAMPLETIME_1CYCLE_5;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN ADC1_Init 2 */

  /* USER CODE END ADC1_Init 2 */

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
  HAL_GPIO_WritePin(GPIOB, MUESTREO_Pin|PROCESAMIENTO_Pin|UI_Pin|TEST_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin : DEBUG_LED_Pin */
  GPIO_InitStruct.Pin = DEBUG_LED_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(DEBUG_LED_GPIO_Port, &GPIO_InitStruct);

  /*Configure GPIO pins : MUESTREO_Pin PROCESAMIENTO_Pin UI_Pin TEST_Pin */
  GPIO_InitStruct.Pin = MUESTREO_Pin|PROCESAMIENTO_Pin|UI_Pin|TEST_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

  /* USER CODE BEGIN MX_GPIO_Init_2 */

  /* USER CODE END MX_GPIO_Init_2 */
}

/* USER CODE BEGIN 4 */

/* USER CODE END 4 */

/* USER CODE BEGIN Header_StartDefaultTask */
/**
  * @brief  Function implementing the MuestreoTask thread.
  * @param  argument: Not used
  * @retval None
  */
/* USER CODE END Header_StartDefaultTask */
void StartDefaultTask(void *argument)
{
  /* USER CODE BEGIN 5 */

	TickType_t delayTick = xTaskGetTickCount();

	// se calibra el ADC
	HAL_ADCEx_Calibration_Start(&hadc1);


	/* Infinite loop */
	for(;;)
	{
		HAL_ADC_Start(&hadc1); // se inicia la conversion
		HAL_ADC_PollForConversion(&hadc1, HAL_MAX_DELAY); // se espera la conversion
		uint32_t adcVal = (3300 * HAL_ADC_GetValue(&hadc1) ) / (4095) ; // se calcula la muestra a mV
		uint16_t sampleBuffer = adcVal; // se guarda el dato en el buffer

		osMessageQueuePut(Q1Handle, &sampleBuffer, 0, 0); // se pone en la cola el dato
		vTaskDelayUntil(&delayTick, 5); // se esperan 5ms
	}
  /* USER CODE END 5 */
}

/* USER CODE BEGIN Header_processingData */
/**
* @brief Function implementing the ProcesamientoTa thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_processingData */
void processingData(void *argument)
{
  /* USER CODE BEGIN processingData */

#define SAMPLE_BUFFER_SIZE (400)
	uint16_t sampleBuffer[SAMPLE_BUFFER_SIZE] = {0};
	uint32_t index = 0;

	/* Infinite loop */
	for(;;)
	{

		// se calcula el promedio
		while (osMessageQueueGet(Q1Handle, &sampleBuffer[index], NULL, 0) == osOK && index < SAMPLE_BUFFER_SIZE){
			index++;
			osDelay(50);
		}

		index = 0;

		uint32_t acc = 0;
		for (uint32_t i = 0; i < SAMPLE_BUFFER_SIZE; i++) {
			acc += sampleBuffer[i];
		}

		uint32_t avg = acc / SAMPLE_BUFFER_SIZE;

		// se crea el mensaje
		QueueMessage_t mesg = {
				.message = MOSTRAR_PROMEDIO,
				.payload = avg,
		};
		osMessageQueuePut(Q2Handle, &mesg, 0, 0); // se envía el mensaje a la cola


#define VCC (3300)
#define VCC_SOBRE_2 (VCC / 2)
		if (avg > VCC_SOBRE_2 && estadoAlarma == DESACTIVADA) {
			QueueMessage_t mesg = {
					.message = ALARMA_ACTIVAR,
					.payload = 0,
			};
			osMessageQueuePut(Q2Handle, &mesg, 0, 0); // se envía el mensaje a la cola
			estadoAlarma = ACTIVA; // se actualiza el estado de la alarma
		} else if (avg < VCC_SOBRE_2 && estadoAlarma == ACTIVA) {
			QueueMessage_t mesg = {
					.message = ALARMA_DESACTIVAR,
					.payload = 0,
			};
			osMessageQueuePut(Q2Handle, &mesg, 0, 0); // se envía el mensaje a la cola
			estadoAlarma = DESACTIVADA; // se actualiza el estado de la alarma
		}

		osDelay(1);

	}
  /* USER CODE END processingData */
}

/* USER CODE BEGIN Header_UI */
/**
* @brief Function implementing the UITask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_UI */
void UI(void *argument)
{
  /* USER CODE BEGIN UI */

	TickType_t delayTick = xTaskGetTickCount();

	QueueMessage_t mesgBuffer; // buffer para el mensaje de la cola Q2

	char buffer_uart_info[40]; // buffer para el UART

  /* Infinite loop */
  for(;;)
  {

	  // se leen los mensajes de la cola y se actúa acorde
	  while (osMessageQueueGet(Q2Handle, &mesgBuffer, NULL, 0) == osOK){
#define MENSAJE_ALARMA_ACTIVADA ("ALARMA ACTIVADA\n")
#define MENSAJE_ALARMA_DESACTIVADA ("ALARMA DESACTIVADA\n")

		  switch (mesgBuffer.message) {
		  case ALARMA_ACTIVAR:
			  snprintf(buffer_uart_info, sizeof(buffer_uart_info), MENSAJE_ALARMA_ACTIVADA);
			  break;
		  case ALARMA_DESACTIVAR:
			  snprintf(buffer_uart_info, sizeof(buffer_uart_info), MENSAJE_ALARMA_DESACTIVADA);
			  break;
		  case MOSTRAR_PROMEDIO:
			  snprintf(buffer_uart_info, sizeof(buffer_uart_info), "DATO: %ld\n", mesgBuffer.payload);
			  break;
		  }

		  HAL_UART_Transmit(&huart1, (uint8_t*)buffer_uart_info, sizeof(buffer_uart_info), HAL_MAX_DELAY);

	  }

	  vTaskDelayUntil(&delayTick, 5000); // se esperan 5 segundos
  }
  /* USER CODE END UI */
}

/**
  * @brief  Period elapsed callback in non blocking mode
  * @note   This function is called  when TIM4 interrupt took place, inside
  * HAL_TIM_IRQHandler(). It makes a direct call to HAL_IncTick() to increment
  * a global variable "uwTick" used as application time base.
  * @param  htim : TIM handle
  * @retval None
  */
void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{
  /* USER CODE BEGIN Callback 0 */

  /* USER CODE END Callback 0 */
  if (htim->Instance == TIM4)
  {
    HAL_IncTick();
  }
  /* USER CODE BEGIN Callback 1 */

  /* USER CODE END Callback 1 */
}

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
