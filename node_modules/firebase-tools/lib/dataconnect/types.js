"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.isGraphQLResponseError = exports.isGraphQLResponse = exports.isMainSchema = exports.mainSchema = exports.mainSchemaYaml = exports.toDatasource = exports.requiresVector = exports.MAIN_SCHEMA_ID = void 0;
exports.MAIN_SCHEMA_ID = "main";
function requiresVector(dm) {
    var _a, _b, _c, _d;
    return (_d = (_c = (_b = (_a = dm === null || dm === void 0 ? void 0 : dm.primaryDataSource) === null || _a === void 0 ? void 0 : _a.postgres) === null || _b === void 0 ? void 0 : _b.requiredExtensions) === null || _c === void 0 ? void 0 : _c.includes("vector")) !== null && _d !== void 0 ? _d : false;
}
exports.requiresVector = requiresVector;
function toDatasource(projectId, locationId, ds) {
    if (ds === null || ds === void 0 ? void 0 : ds.postgresql) {
        return {
            postgresql: {
                database: ds.postgresql.database,
                cloudSql: {
                    instance: `projects/${projectId}/locations/${locationId}/instances/${ds.postgresql.cloudSql.instanceId}`,
                },
                schemaValidation: ds.postgresql.schemaValidation,
            },
        };
    }
    if (ds === null || ds === void 0 ? void 0 : ds.httpGraphql) {
        return {
            httpGraphql: {
                uri: ds.httpGraphql.uri,
                timeout: ds.httpGraphql.timeout,
            },
        };
    }
    return {};
}
exports.toDatasource = toDatasource;
function mainSchemaYaml(dataconnectYaml) {
    var _a;
    if (dataconnectYaml.schema) {
        return dataconnectYaml.schema;
    }
    const mainSch = (_a = dataconnectYaml.schemas) === null || _a === void 0 ? void 0 : _a.find((s) => s.id === exports.MAIN_SCHEMA_ID || !s.id);
    if (!mainSch) {
        throw new Error(`Service ${dataconnectYaml.serviceId} has no main schema defined`);
    }
    return mainSch;
}
exports.mainSchemaYaml = mainSchemaYaml;
function mainSchema(schemas) {
    const mainSch = schemas.find((s) => isMainSchema(s));
    if (!mainSch) {
        throw new Error(`No main schema is defined`);
    }
    return mainSch;
}
exports.mainSchema = mainSchema;
function isMainSchema(schema) {
    return schema.name.endsWith(`/schemas/${exports.MAIN_SCHEMA_ID}`);
}
exports.isMainSchema = isMainSchema;
const isGraphQLResponse = (g) => !!g.data || !!g.errors;
exports.isGraphQLResponse = isGraphQLResponse;
const isGraphQLResponseError = (g) => !!g.error;
exports.isGraphQLResponseError = isGraphQLResponseError;
