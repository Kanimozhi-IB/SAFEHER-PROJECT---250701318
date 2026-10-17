package com.safeher;

import com.safeher.service.Validation;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class ValidationTest {
    @Test void normalizesEmail(){assertEquals("user@example.com",Validation.email(" User@Example.com "));}
    @Test void rejectsInvalidEmail(){assertThrows(IllegalArgumentException.class,()->Validation.email("no-at-sign"));}
    @Test void acceptsPhoneFormatting(){assertEquals("+1 (555) 0100",Validation.phone("+1 (555) 0100"));}
    @Test void rejectsShortPhone(){assertThrows(IllegalArgumentException.class,()->Validation.phone("123"));}
    @Test void requiresBothCoordinates(){assertThrows(IllegalArgumentException.class,()->Validation.coordinates(12.0,null));}
    @Test void rejectsOutOfRangeCoordinates(){assertThrows(IllegalArgumentException.class,()->Validation.coordinates(91.0,10.0));}
}
