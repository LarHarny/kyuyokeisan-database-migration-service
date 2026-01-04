# 数据库迁移服务

这是一个独立的数据库迁移服务，使用 Flyway 管理所有后端服务的数据库迁移脚本。

## 功能

- 集中管理所有后端服务的数据库迁移脚本
- 使用 Flyway 进行版本控制和迁移执行
- 支持生产、开发、测试环境配置

## 迁移脚本

本服务包含以下迁移脚本：

1. **V1__init_employment_insurance_rate_table.sql** - 雇用保险费率表（来自 employmentInsurance-backend-service）
2. **V2__init_premium_bracket_table.sql** - 社会保险费等级表（来自 socialInsurance-backend-service）
3. **V3__init_source_withholding_tax_table.sql** - 源泉征收税额表（来自 sourceWithholdingTax-backend-service）

## 环境变量

服务需要以下环境变量：

- `FLYWAY_URL` - 数据库 JDBC 连接 URL（例如：`jdbc:postgresql://localhost:5432/social_insurance`）
- `DB_USER` - 数据库用户名
- `DB_PASSWORD` - 数据库密码

## 使用方法

### 本地运行

```bash
# 设置环境变量
export FLYWAY_URL=jdbc:postgresql://localhost:5432/social_insurance
export DB_USER=db_user
export DB_PASSWORD=local

# 运行迁移
./gradlew bootRun --args='--spring.profiles.active=dev'
```

### Docker 构建

```bash
# 构建镜像
docker build -f Dockerfile.prod -t database-migration-service:latest .

# 运行容器
docker run --rm \
  -e FLYWAY_URL=jdbc:postgresql://host.docker.internal:5432/social_insurance \
  -e DB_USER=db_user \
  -e DB_PASSWORD=local \
  -e SPRING_PROFILES_ACTIVE=prod \
  database-migration-service:latest
```

### Cloud Run 部署

在 Cloud Run 中部署时，服务会在启动时执行所有待执行的迁移脚本，然后自动退出。

## 注意事项

- 迁移服务执行完迁移后会自动退出（这是正常行为）
- 确保在部署其他后端服务之前先运行迁移服务
- 生产环境建议在 CI/CD 流程中先执行迁移，再部署应用服务

