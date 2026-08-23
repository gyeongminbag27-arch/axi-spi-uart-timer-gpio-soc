# AXI4-Lite Based MicroBlaze SoC Design

MicroBlaze 기반 SoC에서 AXI4-Lite Bus를 이용해 GPIO, UART, Timer, SPI Peripheral을 Memory-Mapped 방식으로 연결하고 제어하는 구조를 학습·구현한 프로젝트입니다.

기존 SoC 구조를 기반으로 Custom SPI AXI IP의 Register Map과 AXI Read/Write Interface를 분석하고 수정했으며, SPI Master Core와의 연동 구조를 구성했습니다.

> **Project Status**
> AXI4-Lite 기반 SoC 및 Peripheral 연결 구조와 Custom SPI Register Interface까지 구현하였으며,
> SPI Master 전체 동작 검증 및 실제 SPI Device 연동은 추가 보완 중입니다.

---

## 1. Project Overview

### 목표

* MicroBlaze Processor와 Peripheral 간 AXI4-Lite 통신 구조 이해
* Memory-Mapped I/O 기반 Peripheral 제어
* Custom AXI Slave IP 설계 및 Register Map 구성
* AXI Register Interface와 SPI Master Core 연결
* Firmware에서 Register 접근을 통한 Hardware 제어 구조 이해

### System Structure

```text
MicroBlaze
    │
    │ AXI4-Lite
    ▼
AXI Interconnect
    │
    ├── GPIO
    ├── UART
    ├── Timer
    │
    └── Custom SPI AXI IP
             │
             ├── Register Interface
             │
             └── SPI Master Core
                    │
                    ├── SCLK
                    ├── MOSI
                    ├── MISO
                    └── CS
```

---

## 2. Development Environment

* FPGA / SoC Tool : Xilinx Vivado
* Processor : MicroBlaze
* Bus : AMBA AXI4-Lite
* RTL : Verilog / SystemVerilog
* Firmware : C
* Peripheral

  * GPIO
  * UART
  * Timer
  * SPI

---

## 3. AXI4-Lite Register Map

Custom SPI AXI IP는 다음과 같은 Register 구조로 구성했습니다.

| Address | Register   | Access | Description                |
| ------- | ---------- | ------ | -------------------------- |
| `0x00`  | SPI_CTRL   | R/W    | SPI Start 및 동작 Mode 설정     |
| `0x04`  | SPI_STATUS | R/W    | Busy / Done / Interrupt 상태 |
| `0x08`  | SPI_CLKDIV | R/W    | SPI Clock Divider 설정       |
| `0x0C`  | SPI_TX     | R/W    | SPI 송신 데이터                 |
| `0x10`  | SPI_RX     | R      | SPI 수신 데이터                 |

### SPI_CTRL

| Bit | Field  | Description        |
| --- | ------ | ------------------ |
| 0   | START  | SPI Transfer 시작    |
| 1   | CPOL   | SPI Clock Polarity |
| 2   | CPHA   | SPI Clock Phase    |
| 3   | INT_EN | Interrupt Enable   |

### SPI_STATUS

| Bit | Field       | Description       |
| --- | ----------- | ----------------- |
| 0   | DONE        | SPI Transfer 완료   |
| 1   | BUSY        | SPI 동작 중          |
| 2   | IRQ_PENDING | Interrupt Pending |

---

## 4. AXI4-Lite Interface

AXI Slave 내부에서 CPU의 Address에 따라 SPI Register를 선택하도록 Address Decode Logic을 구성했습니다.

### Write Flow

```text
CPU Write
   ↓
AXI AWADDR / WDATA
   ↓
AXI Write Handshake
   ↓
Address Decode
   ↓
SPI Register Write
   ↓
SPI Master Control Signal
```

### Read Flow

```text
CPU Read
   ↓
AXI ARADDR
   ↓
Address Decode
   ↓
Register Data Select
   ↓
AXI RDATA
   ↓
CPU
```

이를 통해 Firmware에서 특정 Memory Address에 접근하면 AXI Slave Register를 거쳐 SPI Hardware를 제어할 수 있도록 구성했습니다.

---

## 5. Custom SPI AXI IP

Custom SPI IP는 크게 두 부분으로 구성됩니다.

```text
axi_spi_master_v1_0
│
├── AXI4-Lite Slave Interface
│     ├── Address Decode
│     ├── Register Write
│     └── Register Read
│
└── SPI Master Core
      ├── Clock Generation
      ├── MOSI Transmission
      ├── MISO Reception
      └── CS Control
```

AXI Register Interface와 SPI Master Logic을 분리하여 Processor가 Register를 통해 SPI Core를 제어하는 구조로 구성했습니다.

---

## 6. SPI Transfer Flow

Firmware 기준 SPI Transfer는 다음 흐름을 목표로 구성했습니다.

```text
1. SPI_STATUS의 BUSY 확인
2. SPI_TX에 송신 데이터 Write
3. SPI_CTRL의 START 설정
4. SPI Master Transfer 수행
5. BUSY 해제 및 DONE 확인
6. SPI_RX에서 수신 데이터 Read
```

즉,

```text
Firmware
   ↓
Memory-Mapped Register
   ↓
AXI4-Lite
   ↓
Custom SPI Register
   ↓
SPI Master
   ↓
External Device
```

의 전체 데이터 흐름을 확인하는 것을 목표로 했습니다.

---

## 7. Implemented

* MicroBlaze 기반 AXI4-Lite SoC 구성
* AXI GPIO 연결
* AXI UART 연결
* AXI Timer 연결
* Custom SPI AXI IP 구성
* SPI Register Map 재구성
* AXI Write Address Decode 수정
* AXI Read Data MUX 수정
* SPI Control / Status Register 구성
* SPI TX / RX Register 구성
* SPI Clock Divider Register 구성
* AXI Slave와 SPI Master Core 간 Signal Interface 구성
* 기존 SPI Master RTL 구조 분석 및 연동

---

## 8. Verification / Debugging

AXI4-Lite Register 접근 과정에서 다음 신호와 데이터 흐름을 중심으로 확인했습니다.

```text
CPU
 ↓
AXI Address
 ↓
AXI Handshake
 ↓
Register
 ↓
SPI Control Signal
 ↓
SPI Master
```

문제 발생 시 전체 시스템을 한 번에 확인하기보다,

1. AXI Address가 정상적으로 전달되는지
2. Write / Read Handshake가 정상인지
3. Register 값이 예상대로 변경되는지
4. Register 값이 SPI Core 입력으로 전달되는지
5. SPI 출력 신호가 생성되는지

순서로 범위를 좁혀가며 확인했습니다.

---

## 9. Current Status

### Completed

* [x] MicroBlaze 기반 SoC 구성
* [x] GPIO / UART / Timer Peripheral 연결
* [x] AXI4-Lite 구조 분석
* [x] Custom SPI AXI Slave Register Map 구성
* [x] AXI Write / Read Decode 수정
* [x] SPI Master Core Interface 연결

### In Progress

* [ ] Firmware 기반 전체 SPI Transfer 검증
* [ ] SCLK / MOSI / MISO / CS Simulation 검증
* [ ] SPI RX Data 동작 검증
* [ ] 실제 SPI Device 연동
* [ ] Interrupt 동작 검증

---

## 10. What I Learned

이 프로젝트를 통해 Processor가 Peripheral을 직접 호출하는 것이 아니라,

```text
Processor
→ AXI Bus
→ Address Decode
→ Register
→ RTL Logic
→ Peripheral
```

구조를 통해 Hardware를 제어한다는 것을 확인했습니다.

특히 AXI4-Lite Slave 내부의 Register Map, Address Decode, Write/Read Handshake와 SPI Master Core 사이의 연결을 직접 수정하며 Memory-Mapped I/O 기반 SoC 구조를 학습했습니다.

---

## Repository Note

본 Repository는 교육 과정에서 진행한 AXI4-Lite 기반 SoC 프로젝트를 바탕으로 구조를 분석하고 Custom SPI IP를 추가 수정·보완한 결과를 정리한 것입니다.

현재 전체 기능 검증 및 실제 SPI Device 연동은 추가 진행 중이며, 구현 및 검증 결과에 따라 지속적으로 업데이트할 예정입니다.
