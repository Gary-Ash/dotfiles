# When to Mock

"Mock" here covers every kind of **test double**, an object that stands in for a real dependency in a test (Meszaros):

- **Test stub**: returns canned answers. `DecliningPaymentClient` below is a test stub.
- **Fake**: a working, lightweight implementation, such as an in-memory database.
- **Spy**: records the calls it receives so the test can check them afterwards.
- **Mock**: set up with expected calls and fails the test if they don't happen.

Prefer test stubs and fakes, and assert on outcomes. Use a spy or a mock only when the outgoing call at a system boundary is itself the behavior, such as charging a card or sending an email.

Mock at **system boundaries** only:

- External APIs (payment, email, etc.)
- Databases (sometimes; prefer a test DB)
- Time/randomness
- File system (sometimes)

Don't mock:

- Your own classes/modules
- Internal collaborators
- Anything you control

```swift
// GOOD: Test stub at the external boundary, asserts on the outcome
struct DecliningPaymentClient: PaymentClient {
    func charge(_ amount: Decimal) async throws -> Receipt {
        throw PaymentError.declined
    }
}

@Test("declined card fails the payment")
func declinedCardFailsPayment() async {
    let order = Order(total: 20)
    await #expect(throws: PaymentError.declined) {
        try await processPayment(order, client: DecliningPaymentClient())
    }
}

// BAD: Test stub replaces your own code; the real tax logic is never exercised
struct TaxCalculatorStub: TaxCalculating {
    func tax(on amount: Decimal) -> Decimal { 2 }
}

@Test("order total includes tax")
func orderTotalIncludesTax() {
    let order = Order(subtotal: 20, taxCalculator: TaxCalculatorStub())
    #expect(order.total == 22)
}
```

## Designing for Mockability

At system boundaries, design interfaces that are easy to mock:

**1. Use dependency injection**

Pass external dependencies in rather than creating them internally:

```swift
// Easy to mock
func processPayment(_ order: Order, client: PaymentClient) async throws -> Receipt {
    try await client.charge(order.total)
}

// Hard to mock
func processPayment(_ order: Order) async throws -> Receipt {
    let client = StripeClient(apiKey: ProcessInfo.processInfo.environment["STRIPE_KEY"] ?? "")
    return try await client.charge(order.total)
}
```

**2. Prefer SDK-style interfaces over generic fetchers**

Create specific functions for each external operation instead of one generic function with conditional logic:

```swift
// GOOD: Each method is independently mockable
protocol ShopAPI {
    func user(id: UUID) async throws -> User
    func orders(userID: UUID) async throws -> [Order]
    func createOrder(_ draft: OrderDraft) async throws -> Order
}

// BAD: Mocking requires conditional logic inside the mock
protocol HTTPAPI {
    func fetch(_ path: String, method: String, body: Data?) async throws -> Data
}
```
