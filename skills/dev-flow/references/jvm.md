# Java and Kotlin (JVM and Android Native)

Use only for the affected Gradle or Maven module.

## Discover narrowly

Read `settings.gradle*`, the affected module's `build.gradle*` or `pom.xml`, `gradle/libs.versions.toml`, and toolchain pins. Always prefer repository wrappers (`./gradlew`, `./mvnw`) over globally installed binaries. Distinguish JVM backend/CLI modules (Spring Boot, Ktor, Quarkus, Micronaut) from Android modules (`AndroidManifest.xml`, `namespace`, Compose, platform channels). Ignore `.gradle/`, `build/`, `target/`, `.idea/`, and generated annotation/Kapt/KSP sources.

Do not edit generated sources, lockfiles, or Gradle wrapper jars manually.

## Preserve architecture and boundaries

- Follow established module boundaries, DI/IoC wiring, configuration profiles, and controller → service → repository separation.
- Keep persistence entities (`@Entity`) separate from external API DTOs; avoid exposing lazy-loaded Hibernate/JPA proxies outside transaction boundaries (`@Transactional`).
- Preserve Kotlin null-safety and Java `@Nullable`/`@NonNull` contracts; avoid new Kotlin non-null assertions (`!!`) or raw generic types.
- On Android or Flutter platform plugins, respect main-thread constraints, `Activity`/`Fragment` lifecycle attachment, permissions, and minimum SDK compatibility.

## Concurrency, resource, and query safety

- In Kotlin Coroutines, preserve structured concurrency, inject `CoroutineDispatcher`s for testability, and never swallow `CancellationException` inside broad `catch (e: Exception)` blocks.
- Close I/O streams, JDBC resources, and cursors deterministically via Java `try-with-resources` or Kotlin `.use {}`.
- Guard against JPA/ORM N+1 queries (`JOIN FETCH`, `@EntityGraph`, batching), unbounded pagination, and thread-unsafe shared state in singleton beans.
- On Android UI/Compose, hoist state cleanly, respect lifecycle-aware collection (`repeatOnLifecycle`, `collectAsStateWithLifecycle`), and avoid leaking `Context` or `View` references.

## Verification ladder

Use wrapper tasks from the repository. Run only applicable stages:

1. Formatter and static analysis (`spotlessCheck`, `ktlintCheck`, `detekt`, `checkstyle`, `lintDebug`) on the affected module.
2. Focused unit test (`./gradlew :module:test --tests <Class.method>` or `./mvnw test -Dtest=<Class#method>`).
3. Affected module compilation and unit test suite.
4. Slice or integration tests (`@WebMvcTest`, `@DataJpaTest`, Testcontainers) when HTTP, serialization, or database behavior changed.
5. Package or Android target check (`assembleDebug`, `jar`, native plugin build) when manifests, Gradle config, or DI wiring changed; for Android/desktop UI changes, launch and drive the app visibly on the macOS screen (Android Emulator or desktop window, never headless/hidden).
6. Downstream consumer module tests when shared contracts change.
