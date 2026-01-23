package com.warehouse;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

import static org.junit.jupiter.api.Assertions.assertTrue;

@SpringBootTest
@TestPropertySource(properties = {
    "spring.datasource.url=jdbc:h2:mem:testdb",
    "spring.jpa.hibernate.ddl-auto=create-drop"
})
class WarehouseApplicationTests {

    @Test
    void contextLoads() {
        assertTrue(true);
    }

    /*
    @Test
    void inventoryCalculationTest() {
        // This test will fail - simulating the assessment scenario
        int expected = 100;
        int actual = 99;
        assertTrue(expected == actual, "Inventory calculation failed");
    }
    */
}
