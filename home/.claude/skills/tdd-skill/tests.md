# Good and Bad Tests

## Good Tests

**Behavior-focused**: Test through real interfaces, not mocks of internal parts. One logical assertion per test; the name describes WHAT, not HOW.

```swift
// GOOD: Tests observable behavior
@Test("user can checkout with valid cart")
func checkoutWithValidCart() async throws {
    let product = Product(price: 10)
    let paymentMethod = PaymentMethod.creditCard
    var cart = Cart()
    cart.add(product)
    let result = try await checkout(cart, paymentMethod: paymentMethod)
    #expect(result.status == .confirmed)
}
```

## Bad Tests

**Implementation-detail tests**: See the implementation-coupled anti-pattern in [SKILL.md](SKILL.md) and the internal-collaborator example in [mocking.md](mocking.md). Also red flags:

- Asserting on call counts/order (except at a system boundary, where the call is the behavior; see [mocking.md](mocking.md))
- Test name describes HOW not WHAT

**Side-channel verification**: Checks the result by reaching past the interface.

```swift
// BAD: Bypasses interface to verify
@Test("createUser saves to database")
func createUserSavesToDatabase() async throws {
    try await createUser(name: "Alice")
    let rows = try await db.query("SELECT * FROM users WHERE name = ?", ["Alice"])
    #expect(!rows.isEmpty)
}

// GOOD: Verifies through interface
@Test("createUser makes user retrievable")
func createdUserIsRetrievable() async throws {
    let user = try await createUser(name: "Alice")
    let retrieved = try await getUser(id: user.id)
    #expect(retrieved.name == "Alice")
}
```

**Tautological tests**: Expected value restates the implementation, so the test passes by construction.

```swift
// BAD: Expected value is recomputed the way the code computes it
@Test("calculateTotal sums line items")
func sumsLineItemsTautologically() {
    let items = [LineItem(price: 10), LineItem(price: 5)]
    let expected = items.reduce(0) { $0 + $1.price }
    #expect(calculateTotal(items) == expected)
}

// GOOD: Expected value is an independent, known literal
@Test("calculateTotal sums line items")
func sumsLineItems() {
    #expect(calculateTotal([LineItem(price: 10), LineItem(price: 5)]) == 15)
}
```
